# GitHub Secrets Configuration

Para que los workflows funcionen correctamente, necesitas configurar los siguientes secrets en GitHub:

## Configuración de Secrets

Ve a: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### Secrets Requeridos

| Secret | Descripción | Ejemplo |
|--------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID para deployment | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `CLOUDFLARE_API_TOKEN` | Token API de Cloudflare | `your-cloudflare-api-token` |
| `CLOUDFLARE_ZONE_ID` | Zone ID del dominio en Cloudflare | `your-zone-id` |
| `AMPLIFY_GITHUB_TOKEN` | GitHub Personal Access Token para Amplify | `ghp_xxxxxxxxxxxx` |

## Cómo obtener cada secret

### AWS Credentials
```bash
# Crear usuario IAM con permisos necesarios
# Descargar las credenciales y agregar como secrets
```

### Cloudflare API Token
1. Ir a https://dash.cloudflare.com/profile/api-tokens
2. Crear token con permisos: Zone:DNS:Edit
3. Copiar el token generado

### Cloudflare Zone ID
1. Ir a tu dominio en Cloudflare Dashboard
2. En la barra lateral derecha, copiar el "Zone ID"

### GitHub Token para Amplify
1. Ir a https://github.com/settings/tokens
2. Generate new token (classic)
3. Seleccionar scopes: `repo`, `admin:repo_hook`

## Terraform Backend (Opcional)

Si usas S3 backend para Terraform state:

| Secret | Descripción |
|--------|-------------|
| `TF_BACKEND_BUCKET` | Nombre del bucket S3 |
| `TF_BACKEND_KEY` | Ruta del state file |
| `TF_BACKEND_REGION` | Región del bucket |

## Verificar Secrets

Después de configurar, puedes verificar ejecutando:
- Un push a rama `develop` (ejecuta tests solamente)
- Un push a rama `main` (ejecuta tests + deployment)

## Seguridad

⚠️ **NUNCA** commits secrets en el código
✅ Usa GitHub Secrets para todas las credenciales
✅ Rota las credenciales regularmente
✅ Usa permisos mínimos necesarios (IAM least privilege)
