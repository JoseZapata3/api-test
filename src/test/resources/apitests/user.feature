Feature: Gestión de usuarios vía API REST

  Background:
    Given la API está disponible en "http://localhost:8087/api/v1"

  Scenario: Crear un nuevo usuario
    When envío una solicitud POST a "/users" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
        "password": "Password1)S1",
        "firstName": "Jose",
        "lastName": "Zapata",
        "email": "josezapata75235@gmail.com",
        "country": "Colombia",
        "phonePrefix": "+57",
        "phone": "3152971212",
        "dateBirth": "2000-02-03",
        "role": "PROFESSOR"
      }
      """
    Then la respuesta debe tener un código 201
    And el cuerpo de respuesta debe contener el campo "id"

  Scenario: Solicitar al servidor el jwt
    When envío una solicitud POST a "/auth/login" con el cuerpo:
          """
          {
           "username": "jose.alejandro",
           "password": "Password1)S1"
          }
          """
    Then el cuerpo de respuesta debe contener el campo "token"

  Scenario: Crear, autenticar y eliminar un usuario
    When envío una solicitud POST a "/users" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
       "password": "Password1)S1",
       "firstName": "Jose",
       "lastName": "Zapata",
       "email": "josezapata75235@gmail.com",
       "country": "Colombia",
       "phonePrefix": "+57",
       "phone": "3152971212",
       "dateBirth": "2000-02-03",
       "role": "PROFESSOR"
      }
      """
    And el cuerpo de respuesta debe contener el campo "id"
    When envío una solicitud POST a "/auth/login" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
       "password": "Password1)S1"
      }
      """
    And la respuesta debe tener un código 200
    And existe un usuario con ID 1
    When envío una solicitud DELETE a "/users"
    Then la respuesta debe tener un código 204

  Scenario: Crear usuarios, autenticar y listar usuarios
    When envío una solicitud POST a "/users" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
       "password": "Password1)S1",
       "firstName": "Jose",
       "lastName": "Zapata",
       "email": "jazapatao_1@uqvirtual.edu.co",
       "country": "Colombia",
       "phonePrefix": "+57",
       "phone": "3152971212",
       "dateBirth": "2000-02-03",
       "role": "PROFESSOR"
      }
      """
    And el cuerpo de respuesta debe contener el campo "id"
    When envío una solicitud POST a "/users" con el cuerpo:
      """
      {
       "username": "bryan.gomez",
       "password": "Password1)S1",
       "firstName": "Bryan",
       "lastName": "Gomez",
       "email": "jazapatao_1@uqvirtual.edu.co",
       "country": "Colombia",
       "phonePrefix": "+57",
       "phone": "3152971212",
       "dateBirth": "2000-02-03",
       "role": "STUDENT"
      }
      """
    And el cuerpo de respuesta debe contener el campo "id"
    When envío una solicitud POST a "/auth/login" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
       "password": "Password1)S1"
      }
      """
    And la respuesta debe tener un código 200
    When envío una solicitud GET a "/users"
    Then la respuesta debe tener un código 200
    And el cuerpo debe ser una lista de usuarios

  Scenario: Crear y eliminar un usuario sin token
    When envío una solicitud POST a "/users" con el cuerpo:
      """
      {
       "username": "jose.alejandro",
       "password": "Password1)S1",
       "firstName": "Jose",
       "lastName": "Zapata",
       "email": "josezapata75235@gmail.com",
       "country": "Colombia",
       "phonePrefix": "+57",
       "phone": "3152971212",
       "dateBirth": "2000-02-03",
       "role": "PROFESSOR"
      }
      """
    Given existe un usuario con ID 1
    When envío una solicitud DELETE a "/users"
    Then la respuesta debe tener un código 401

  Scenario: Listar todos los usuarios sin token
    When envío una solicitud GET a "/users"
    Then la respuesta debe tener un código 401