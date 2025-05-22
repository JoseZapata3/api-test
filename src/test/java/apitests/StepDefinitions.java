package apitests;

import io.cucumber.java.en.*;
import io.restassured.response.Response;
import io.restassured.RestAssured;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class StepDefinitions {
    private String baseUrl;
    private Response response;
    private String token;
    private int userId;

    @Given("la API está disponible en {string}")
    public void la_api_esta_disponible(String url) {
        this.baseUrl = url;
    }

    @Given("existe un usuario con ID {int}")
    public void existe_un_usuario_con_id(Integer userId) {
       this.userId = userId;
    }

	@Given("el usuario {string} no existe")
	public void el_usuario_no_existe(String username) {
		Response response = RestAssured
				.given()
				.contentType("application/json")
				.body("{\"username\": \"" + username + "\", \"password\": \"Password1)S1\"}")
				.when()
				.post(baseUrl + "/auth/login");

		int status = response.getStatusCode();

		if (status == 200) {
			throw new AssertionError("El usuario '" + username + "' ya existe. El paso requiere que no exista.");
		}
	}


	@Given("no existe un recurso en {string} con el cuerpo:")
	public void no_existe_recurso(String endpoint, String body) {
		Response checkResponse = RestAssured
			.given()
			.contentType("application/json")
			.body(body)
			.when()
			.post(baseUrl + endpoint);

		int status = checkResponse.getStatusCode();
		if (status == 200) {
			throw new AssertionError("El recurso ya existe según la verificación en " + endpoint);
		}
	}

	@When("envío una solicitud POST a {string} con el cuerpo:")
	public void envio_post_con_body(String endpoint, String body) {
		response = RestAssured
				.given().contentType("application/json")
				.body(body)
				.when().post(baseUrl + endpoint);

		if (endpoint.equals("/auth/login")) {
			this.token = response.jsonPath().getString("token");
		}
	}

	@When("envío una solicitud GET a {string}")
	public void envio_get(String endpoint) {
		response = RestAssured
				.given()
				.header("Authorization", "Bearer " + this.token)
				.get(baseUrl + endpoint);
	}

	@When("envío una solicitud PUT a {string} con el cuerpo:")
	public void envio_put_con_body(String endpoint, String body) {
		response = RestAssured
				.given().contentType("application/json")
				.body(body)
				.when().put(baseUrl + endpoint);
	}

	@When("envío una solicitud DELETE a {string}")
	public void envio_delete(String endpoint) {
		System.out.println("my url " + baseUrl + endpoint + "/" + this.userId);
		response = RestAssured
				.given()
				.header("Authorization", "Bearer " + this.token)
				.when()
				.delete(baseUrl + endpoint + "/" + this.userId);
	}

	@Then("la respuesta debe tener un código {int}")
	public void verificar_codigo(int statusCode) {
		assertThat(response.getStatusCode(), is(statusCode));
	}

	@Then("el cuerpo de respuesta debe contener el campo {string}")
	public void verificar_campo_en_respuesta(String campo) {
		assertThat(response.getBody().jsonPath().get(campo), is(notNullValue()));
	}

	@Then("el campo {string} en la respuesta debe ser {string}")
	public void verificar_valor_en_respuesta(String campo, String valorEsperado) {
		assertThat(response.jsonPath().getString(campo), equalTo(valorEsperado));
	}

	@Then("el cuerpo debe contener {string} y {string}")
	public void verificar_campos(String campo1, String campo2) {
		assertThat(response.jsonPath().get(campo1), is(notNullValue()));
		assertThat(response.jsonPath().get(campo2), is(notNullValue()));
	}

	@Then("el cuerpo debe ser una lista de usuarios")
	public void verificar_lista() {
		assertThat(response.jsonPath().getList("$"), is(not(empty())));
	}
}