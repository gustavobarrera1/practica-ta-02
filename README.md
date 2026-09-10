# Tech Assignment de Práctica — Junior DevOps Engineer

## Objetivo

Diseñar e implementar un flujo CI/CD para una aplicación web desplegada en Amazon ECS y Amazon ECR. El proyecto utiliza Terraform para el aprovisionamiento de infraestructura inmutable y GitHub Actions para la automatización del despliegue continuo.

## Arquitectura y Tecnologías

* Docker
* Terraform 
* GitHub Actions 
* AWS (ECS Fargate, ECR, ALB, VPC, IAM, S3, STS)

## Pasos para Desplegar

### Clonar el repositorio

```bash
git clone [https://github.com/gustavobarrera1/practica-ta-02](https://github.com/gustavobarrera1/practica-ta-02)
cd practica-ta-02
```

### Configurar variables y secretos en GitHub
En el repositorio, configurar los siguientes **Secrets/Variables** en `Settings > Secrets and variables > Actions`:
* `AWS_IAM_ROLE`: ARN del rol de IAM con permisos (OIDC) o credenciales de despliegue.
* `AWS_REGION`: Región de despliegue (ej. `us-east-1`).
* `ECS_TASK_DEF_MEMORY`: Memoria para la tarea (ej. `512`).
* `ECS_TASK_DEF_CPU`: CPU para la tarea (ej. `256`).

### Aprovisionar la Infraestructura base (Bootstrap)
Ejecutar el workflow de Terraform desde la pestaña **Actions** en GitHub:
1. Seleccionar el workflow **Terraform**.
2. Hacer clic en **Run workflow**.
*(Este paso creará la VPC, Load Balancer, Cluster ECS, repositorio ECR y un servicio inicial usando una imagen dummy de Nginx).*

### Desplegar la Aplicación
Una vez que Terraform finalice exitosamente, se disparará automáticamente el workflow **Deploy to Amazon ECS**.
*(Este paso compilará la imagen de Flask, la escaneará con Trivy, la subirá a ECR y actualizará la Task Definition del servicio ECS).*

### Verificar el estado de la aplicación
Obtener el DNS del Application Load Balancer (disponible en los outputs de Terraform o en la consola de AWS) e ingresar desde el navegador:

## Decisiones Técnicas

Terraform administra exclusivamente la infraestructura base, mientras que GitHub Actions gestiona qué versión de la aplicación se ejecuta en ECS. Esto evita dependencias circulares y bloqueos en los pipelines.

Para el despliegue en ECS se optó por el modelo configurando la red en modo `awsvpc`. Esto permitió que el Application Load Balancer enrute el tráfico directamente a las IPs de las tareas de contenedor en el puerto 5000, eliminando la necesidad de gestionar instancias EC2 subyacentes.

Se evitó hardcodear identificadores de cuenta de AWS en el código fuente. En su lugar, el pipeline de CD consulta la identidad de quien llama mediante `aws sts get-caller-identity` e inyecta dinámicamente el `ExecutionRoleArn` utilizando comandos de textoen tiempo de ejecución, garantizando la portabilidad del repositorio.

## Variables y Validaciones

Se integró **Trivy** en el pipeline de GitHub Actions para realizar un análisis de vulnerabilidades de la imagen de contenedor previo a su publicación en ECR.

Se configuraron flujos dependientes en GitHub Actions (`workflow_run`), condicionando la ejecución del despliegue de la aplicación únicamente si la infraestructura fue aprovisionada con estado `success`.

## Problemas Encontrados

**Bootstrap:** Terraform necesitaba una Task Definition con una imagen válida para crear el ECS Service, pero la imagen real aún no existía en ECR porque GitHub Actions no había corrido. Se solucionó provisionando inicialmente una imagen dummy (`nginx:alpine`) y utilizando el bloque `lifecycle { ignore_changes = [task_definition] }` en Terraform. Esto permitió crear el servicio la primera vez y ceder el control de futuras actualizaciones de imagen a GitHub Actions.

**Permisos IAM restrictivos en pipelines:** Se ajustaron las políticas granulares del rol en AWS para habilitar el ciclo de vida completo de la infraestructura.


## Video de demostración en AWS:

https://drive.google.com/file/d/19G6aa9MBqGYWFbxH2mgD3vy8QbEwoLaM/view