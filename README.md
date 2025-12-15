# 🚀 Infraestructura AWS con Terraform

> Infraestructura completa para hosting de sitio web estático con dominio personalizado, certificado SSL y API de contador de visitas.

## 📦 Componentes

| Servicio | Descripción |
|----------|-------------|
| **Route 53** | Hosted Zone para `aws10.ikerdemo.cat` |
| **Cloudflare** | Delegación DNS del subdominio |
| **ACM** | Certificado SSL/TLS con validación automática |
| **Amplify** | Hosting del sitio desde GitHub |
| **DynamoDB** | Base de datos de contador de visitas |
| **Lambda** | 2 funciones para gestionar visitas |
| **API Gateway** | API REST pública para el contador |

---

## 🎯 Resultado Final

- **Sitio web**: `https://cv.aws10.ikerdemo.cat`
- **API**: `https://[api-id].execute-api.us-east-1.amazonaws.com/prod/visits/{page_id}`
- **Certificado SSL**: Automático y renovable
- **Contador de visitas**: API REST con DynamoDB

---

## ⚙️ Requisitos Previos

- ✅ Terraform >= 1.0
- ✅ AWS CLI configurado
- ✅ Cuenta de Cloudflare con API Token
- ✅ Repositorio de GitHub (público o privado)
- ✅ PowerShell 5.1+

---

## 🚀 Despliegue Completo

### **Paso 1: Configurar Variables**

Copia y edita el archivo de configuración:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars
```

**Configura estos valores:**

```hcl
domain_name            = "tudominio.com"          # Tu dominio en Cloudflare
intermediate_subdomain = "aws10"                  # Subdominio intermedio
subdomain              = "cv"                     # Subdominio final
cloudflare_zone_id     = "tu-zone-id"            # ID de Cloudflare
cloudflare_api_token   = "tu-token"              # Token de API
amplify_repository_url = "https://github.com/usuario/repo"
amplify_github_token   = "ghp_xxxxx"             # Token de GitHub
```

### **Paso 2: Inicializar Terraform**

```powershell
terraform init
```

### **Paso 3: Verificar Plan**

```powershell
terraform plan
```

### **Paso 4: Desplegar Infraestructura**

**⚠️ IMPORTANTE**: Debes desplegar en orden debido a dependencias DNS.

**4.1. Crear Route 53**
```powershell
terraform apply -target="module.route53"
```

**4.2. Configurar Cloudflare** 
```powershell
terraform apply -target="module.cloudflare"
```

**4.3. Esperar Propagación DNS (2-3 minutos)**
```powershell
Start-Sleep -Seconds 180
```

**4.4. Crear Todo lo Demás**
```powershell
terraform apply
```

### **Paso 5: Migrar a GitHub App** *(Opcional)*

1. Ve a la consola de AWS Amplify
2. Click en **"Migrate to GitHub App"**
3. Autoriza la aplicación
4. Comenta el token en `terraform.tfvars`:

```powershell
# Editar archivo
notepad terraform.tfvars

# Comentar esta línea:
# amplify_github_token = "ghp_xxxxx"
```

5. Aplicar cambios:
```powershell
terraform apply
```

---

## 🔍 Verificar Despliegue

### **Ver Outputs**

```powershell
# Ver todos los outputs
terraform output

# Ver URL del sitio
terraform output amplify_custom_domain_url

# Ver endpoint de la API
terraform output api_gateway_endpoint
```

### **Probar la API**

```powershell
# Obtener contador de visitas
curl https://[api-id].execute-api.us-east-1.amazonaws.com/prod/visits/cv

# Incrementar contador
curl -X POST https://[api-id].execute-api.us-east-1.amazonaws.com/prod/visits/cv
```

---

## 📁 Estructura del Proyecto

```
terraform-page/
├── main.tf                      # Configuración principal
├── variables.tf                 # Definición de variables
├── terraform.tfvars            # Valores de variables (NO versionar)
├── terraform.tfvars.example    # Plantilla de ejemplo
├── outputs.tf                  # Outputs
├── providers.tf                # Configuración de providers
├── README.md                   # Esta documentación
├── QUICKSTART.md              # Guía rápida
└── modules/
    ├── route53/               # Hosted Zone
    ├── cloudflare/            # NS records
    ├── acm/                   # Certificado SSL
    ├── amplify/               # Hosting
    ├── dynamodb/              # Base de datos
    ├── lambda/                # Funciones
    └── api_gateway/           # API REST
```

---

## 🛠️ Comandos Útiles

### **Gestión de Infraestructura**

```powershell
# Ver estado actual
terraform show

# Reformatear código
terraform fmt -recursive

# Validar configuración
terraform validate

# Ver outputs específicos
terraform output api_gateway_endpoint

# Destruir TODO (⚠️ CUIDADO)
terraform destroy
```

### **Debugging**

```powershell
# Logs detallados
$env:TF_LOG="DEBUG"
terraform apply

# Ver plan sin aplicar
terraform plan -out=plan.tfplan
terraform show plan.tfplan
```

---

## 🎨 Uso de la API en tu Sitio

Agrega este código a tu `index.html`:

```html
<script>
// Auto-incrementar visitas al cargar
fetch('https://[TU-API-ID].execute-api.us-east-1.amazonaws.com/prod/visits/cv', {
  method: 'POST'
})
.then(res => res.json())
.then(data => console.log('Visitas:', data.visit_count));

// Obtener y mostrar contador
fetch('https://[TU-API-ID].execute-api.us-east-1.amazonaws.com/prod/visits/cv')
  .then(res => res.json())
  .then(data => {
    document.getElementById('visits').textContent = data.visit_count;
  });
</script>

<p>Visitas: <span id="visits">0</span></p>
```

---

## ⚠️ Notas Importantes

### **AWS Academy**
- ✅ Compatible con todas las restricciones
- ✅ Usa `LabRole` existente (no crea roles IAM)
- ⏱️ Sesiones expiran después de 4 horas

### **Tiempos de Propagación**
- 🕐 Route 53 → Cloudflare: 2-3 minutos
- 🕐 Validación ACM: 5-10 minutos  
- 🕐 Dominio Amplify: 10-15 minutos

### **Costos** *(fuera de AWS Academy)*
- Route 53: ~$0.50/mes por Hosted Zone
- DynamoDB: On-demand, ~$0.25 por millón de lecturas
- Lambda: 1M invocaciones gratis/mes
- API Gateway: 1M llamadas gratis/mes
- Amplify: Build gratis, hosting muy bajo

---

## 🆘 Solución de Problemas

### **Error: Certificate validation timeout**
```powershell
# Verifica NS en Cloudflare
nslookup -type=NS aws10.ikerdemo.cat

# Espera más tiempo
Start-Sleep -Seconds 300
terraform apply
```

### **Error: GitHub token invalid**
- Verifica que el token tenga scope `repo`
- Genera uno nuevo en: https://github.com/settings/tokens

### **Error: Amplify build failed**
- Verifica que `index.html` esté en la raíz del repositorio
- Revisa logs en la consola de AWS Amplify

### **Error: IAM CreateRole denied**
- ✅ Normal en AWS Academy
- ✅ Ya configurado para usar `LabRole`

---

## 🧹 Limpiar Todo

```powershell
# Destruir en orden inverso (recomendado)
terraform destroy -target="module.amplify"
terraform destroy -target="module.api_gateway"
terraform destroy -target="module.lambda"
terraform destroy -target="module.dynamodb"
terraform destroy -target="module.acm"
terraform destroy -target="module.cloudflare"
terraform destroy -target="module.route53"

# O destruir todo de una vez
terraform destroy
```

---

## 📚 Recursos Adicionales

- [Documentación de Terraform](https://www.terraform.io/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Cloudflare Provider Docs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)

---

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.
