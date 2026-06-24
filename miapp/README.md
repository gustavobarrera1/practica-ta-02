# Ejecucion mediante dockerfile
* Creacion de imagen del contenedor:

    <sub>docker build . -t gustavobarrera/flaskapp:v1</sub>
  
* Ejecución del contenedor previamente creado:
  
    <sub>docker run --name miapp-test -p 5000:5000 -v $(pwd)/user_data:/app/instance -d gustavobarrera/flaskapp
:v1</sub>

# Ejecucion mediante docker compose
* Una vez clonado el repositorio, dentro de la carpeta de trabajo ejecutamos:

    <sub>docker compose -f docker-compose.yaml up -d</sub>