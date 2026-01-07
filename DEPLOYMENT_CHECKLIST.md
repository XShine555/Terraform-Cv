# 🚀 Checklist de Deployment

## 📋 Pre-requisitos

- [ ] Cuenta de AWS activa
- [ ] Cuenta de Cloudflare con dominio configurado
- [ ] Repositorio GitHub con tu sitio web en carpeta `public/`
- [ ] Terraform instalado localmente
- [ ] AWS CLI instalado

---

## 1️⃣ Configurar AWS Localmente

```powershell
# Configurar credenciales AWS
aws configure
# AWS Access Key ID: [Tu Access Key]
# AWS Secret Access Key: [Tu Secret Key]
# Default region: us-east-1
# Default output format: json

# Verificar que funciona
aws sts get-caller-identity
```

---

## 2️⃣ Crear Bucket S3 para Terraform State

```powershell
# Crear bucket único (cambiar por tu nombre único)
aws s3 mb s3://terraform-state-iker-cv-2026 --region us-east-1

# Habilitar versionado
aws s3api put-bucket-versioning `
  --bucket terraform-state-iker-cv-2026 `
  --versioning-configuration Status=Enabled

# (Opcional) Crear tabla DynamoDB para locks
aws dynamodb create-table `
  --table-name terraform-state-lock `
  --attribute-definitions AttributeName=LockID,AttributeType=S `
  --key-schema AttributeName=LockID,KeyType=HASH `
  --billing-mode PAY_PER_REQUEST `
  --region us-east-1
```

---

## 3️⃣ Actualizar backend.tf

```powershell
# Editar backend.tf y cambiar el nombre del bucket
# bucket = "terraform-state-iker-cv-2026"  # <-- Tu bucket
```

**Archivo:** `backend.tf`
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-iker-cv-2026"  # ⚠️ CAMBIAR
    key            = "terraform-page/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

---

## 4️⃣ Verificar terraform.tfvars

**Archivo:** `terraform.tfvars`

- [x] `domain_name` = "ikerdemo.cat"
- [x] `cloudflare_zone_id` = "94617a6d..."
- [x] `cloudflare_api_token` = "gx0QwQ..."
- [x] `amplify_repository_url` = "https://github.com/XShine555/ikerdemocv"
- [x] `amplify_github_token` = "ghp_EITN..."

⚠️ **IMPORTANTE:** NO hagas commit de este archivo con tokens reales

---

## 5️⃣ Aplicar Terraform Localmente

```powershell
# Navegar a la carpeta del proyecto
cd C:\Users\Iker.A80783858604021\Downloads\terraform-page

# Inicializar Terraform
terraform init

# Ver qué se va a crear (revisar cuidadosamente)
terraform plan

# Aplicar cambios
terraform apply

# Confirmar con: yes
```

**Tiempo estimado:** 5-10 minutos

---

## 6️⃣ Configurar GitHub Secrets

Ve a: `https://github.com/XShine555/ikerdemocv/settings/secrets/actions`

Click en **"New repository secret"** y agrega:

| Nombre | Valor |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | Tu AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Tu AWS Secret Access Key |
| `CLOUDFLARE_API_TOKEN` | `gx0QwQoUoGjBhAzyNWXdPNkW75PGjgJOj_ikkw0A` |
| `CLOUDFLARE_ZONE_ID` | `94617a6d29c32fdea019e2f4eaa18d11` |
| `AMPLIFY_GITHUB_TOKEN` | `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` |
| `DOMAIN_NAME` | `ikerdemo.cat` |
| `INTERMEDIATE_SUBDOMAIN` | `aws10` |
| `SUBDOMAIN` | `cv` |
| `AMPLIFY_APP_NAME` | `cv-portfolio` |
| `AMPLIFY_REPOSITORY_URL` | `https://github.com/XShine555/ikerdemocv` |
| `AMPLIFY_BRANCH` | `main` |

---

## 7️⃣ Limpiar terraform.tfvars

```powershell
# Crear copia de seguridad
cp terraform.tfvars terraform.tfvars.backup

# Comentar tokens sensibles
# O eliminar el archivo del repo
```

**Opción A:** Agregar a `.gitignore`
```powershell
echo "terraform.tfvars" >> .gitignore
echo "terraform.tfvars.backup" >> .gitignore
echo "*.tfstate" >> .gitignore
echo "*.tfstate.backup" >> .gitignore
```

**Opción B:** Comentar tokens
```hcl
# cloudflare_api_token  = ""  # Configurado en GitHub Secrets
# amplify_github_token   = ""  # Configurado en GitHub Secrets
```

---

## 8️⃣ Ejecutar Tests Localmente

```powershell
# Instalar dependencias Python
cd modules\lambda\functions
pip install -r requirements-test.txt

# Ejecutar tests
python -m unittest discover -s . -p "test_*.py" -v

# Debe mostrar: OK (14 tests)
```

---

## 9️⃣ Commit y Push

```powershell
# Volver a raíz
cd C:\Users\Iker.A80783858604021\Downloads\terraform-page

# Ver cambios
git status

# Agregar archivos (excepto terraform.tfvars si tiene tokens)
git add .
git commit -m "Add GitHub Actions CI/CD and update configuration"

# Push a GitHub
git push origin main
```

---

## 🔟 Verificar GitHub Actions

1. Ve a: `https://github.com/XShine555/ikerdemocv/actions`
2. Verás el workflow "Test and Deploy" ejecutándose
3. Espera a que termine (~3-5 minutos)

**Si falla:**
- Revisa los logs en la pestaña Actions
- Verifica que todos los secrets estén configurados
- Asegúrate de que el backend S3 existe

---

## ✅ Verificación Final

```powershell
# Ver outputs de Terraform
terraform output

# Probar el sitio web
# URL: https://cv.aws10.ikerdemo.cat

# Probar API de visitas (después del deploy)
terraform output api_gateway_url
# Ejemplo: https://xxxxxxx.execute-api.us-east-1.amazonaws.com/prod/visits/home
```

---

## 🛠️ Troubleshooting

### Error: "Backend initialization required"
```powershell
terraform init -reconfigure
```

### Error: "Bucket does not exist"
Verifica el nombre del bucket en `backend.tf` y que existe:
```powershell
aws s3 ls | findstr terraform-state
```

### GitHub Actions falla en Terraform Init
Verifica que todos los secrets estén configurados correctamente

### Tests fallan localmente
```powershell
# Verificar región AWS
$env:AWS_DEFAULT_REGION="us-east-1"
python -m unittest discover -s . -p "test_*.py" -v
```

---

## 📝 Notas Importantes

⚠️ **NUNCA** hagas commit de:
- `terraform.tfvars` con tokens reales
- Archivos `.tfstate`
- Credenciales AWS

✅ **Usa siempre**:
- GitHub Secrets para credenciales
- S3 backend para el state
- `.gitignore` para archivos sensibles

🔄 **Workflow CI/CD:**
- Push a `develop` → Solo tests
- Push a `main` → Tests + Deploy automático
- Pull Request → Tests + validación

---

## 🎯 Resultado Esperado

Al finalizar tendrás:
- ✅ Infraestructura en AWS desplegada
- ✅ Sitio web en `https://cv.aws10.ikerdemo.cat`
- ✅ API de contador de visitas funcionando
- ✅ CI/CD automático en GitHub Actions
- ✅ Tests ejecutándose en cada push
- ✅ State de Terraform seguro en S3
