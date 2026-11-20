
# Taller 13 — Ciberseguridad Distribuida y Zero Trust

## Institución
Institución Universitaria Antonio José Camacho

**Asignatura:** Arquitectura de Sistemas Computacionales  
**Tema:** Ciberseguridad Distribuida y Arquitectura Zero Trust

## Integrantes
- Julián Andrés Vásquez García
- Jean Carlos López Lenis
- Gissela Mina Charrupi
- Alkigner Cuesta Rodríguez

## 1. Descripción del proyecto

Este repositorio contiene el desarrollo del Taller 13, en el cual se implementaron diferentes mecanismos de seguridad bajo el modelo Zero Trust.

El trabajo se desarrolló en tres escenarios: MetroMIO, HospitValle y AgroSugar.

El propósito fue fortalecer la autenticación de dispositivos, proteger información sensible y restringir las comunicaciones no autorizadas dentro de una arquitectura distribuida.

## 2. Herramientas utilizadas

- Ubuntu Linux
- Oracle VirtualBox
- Docker
- Kubernetes
- kind
- Calico
- OpenSSL
- Nginx
- PostgreSQL
- LUKS2 y cryptsetup
- Sealed Secrets
- kubectl
- Gitleaks

## 3. Reto 1 — MetroMIO: autenticación mTLS

Se implementó autenticación mutua TLS para proteger las comunicaciones entre los buses y el servidor.

### Actividades realizadas
- Creación de una autoridad certificadora interna.
- Generación de certificados digitales.
- Configuración del servidor Nginx.
- Validación de conexiones mediante mTLS y TLS 1.3.

### Resultados
1. Conexión sin certificado: rechazada, HTTP 400.
2. Conexión con certificado legítimo: aceptada, HTTP 200.
3. Conexión con certificado de autoridad falsa: rechazada.
4. Conexión usando TLS 1.2: rechazada.

**Carpeta:** `reto1-mtls/`

## 4. Reto 2 — HospitValle: protección de datos

Se implementaron controles de protección para la información hospitalaria.

### Actividades realizadas
- Cifrado de almacenamiento mediante LUKS2.
- Creación y utilización de volúmenes cifrados.
- Implementación de una base de datos PostgreSQL de prueba.
- Protección de credenciales mediante Sealed Secrets.
- Configuración de permisos RBAC.
- Aplicación de SecurityContext.

### Resultados
- Disco cifrado: 0 coincidencias en la búsqueda del identificador del paciente.
- Disco sin cifrar: 2 coincidencias.
- Cuenta de servicio con acceso limitado a la configuración autorizada.
- Restricción de lectura de secretos y eliminación de Pods.
- Bloqueo de escritura en rutas protegidas del contenedor.

**Carpeta:** `reto2-hospitvalle/`

Las imágenes de discos, contraseñas y claves privadas no se incluyen en el repositorio público.

## 5. Reto 3 — AgroSugar: microsegmentación

Se implementó un broker MQTT en Kubernetes y se configuraron políticas de red mediante Calico.

### Actividades realizadas
- Creación del namespace agrosugar.
- Implementación del broker MQTT.
- Creación de un sensor autorizado y un sensor intruso.
- Verificación de conectividad inicial.
- Aplicación de una NetworkPolicy para restringir el acceso.

### Resultados documentados
- Antes de aplicar la política, ambos sensores podían conectarse al broker.
- Después de aplicar la política, el sensor autorizado mantuvo el acceso.
- El sensor intruso fue bloqueado y presentó TimeoutError.
- Los Pods continuaron funcionando.

**Carpeta:** `reto3-agrosugar/`

## 6. Verificaciones principales

### Comprobar el clúster
`kind get clusters`

`kubectl get nodes`

### Comprobar HospitValle
`kubectl -n hospitvalle get pods`

`kubectl -n hospitvalle get sealedsecret,secret`

### Comprobar AgroSugar
`kubectl -n agrosugar get pods,svc,networkpolicy`

`kubectl -n agrosugar describe networkpolicy permitir-solo-sensor-autorizado`

Estas comprobaciones requieren tener el clúster configurado y funcionando. La recreación completa del entorno depende de los requisitos y configuraciones documentados en el informe.

## 7. Auditoría de seguridad

Se ejecutó Gitleaks para identificar posibles secretos expuestos.

### Resultado
- Commits analizados: 2.
- Hallazgos reportados: 1.
- Archivo señalado: `reto2-hospitvalle/k8s/01-sealed-pg-uci-cred.yaml`.

El hallazgo corresponde a un valor dentro de `encryptedData` de un recurso SealedSecret.

Se considera un posible falso positivo pendiente de validación definitiva.

También se verificó que no estuvieran registrados archivos de claves privadas ni imágenes de discos con las extensiones revisadas.

La evidencia se conserva en:

`evidencias/auditoria_seguridad.txt`

## 8. Evidencias

La carpeta `evidencias/` contiene los resultados de comprobaciones del laboratorio.

El informe de evidencias del taller documenta el procedimiento realizado mediante 38 figuras correspondientes a los tres escenarios.

## 9. Organización del repositorio

- `reto1-mtls/`: autenticación mediante certificados y Nginx.
- `reto2-hospitvalle/`: cifrado y controles de acceso.
- `reto3-agrosugar/`: broker MQTT y políticas de red.
- `evidencias/`: resultados y auditoría.
- `kind-zerotrust.yaml`: configuración del clúster kind.

## 10. Conclusiones

El desarrollo del taller permitió comprender que la seguridad Zero Trust requiere verificar las identidades, proteger la información y restringir los accesos.

MetroMIO permitió comprobar la autenticación mediante certificados digitales.

HospitValle permitió demostrar la protección de datos mediante cifrado y control de privilegios.

AgroSugar permitió comprobar cómo una política de red puede restringir comunicaciones no autorizadas entre servicios.

Los tres escenarios evidencian la importancia de implementar controles de seguridad complementarios en arquitecturas distribuidas.
