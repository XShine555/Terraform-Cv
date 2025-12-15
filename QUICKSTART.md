# ⚡ Guía de Despliegue Rápido

> Despliega toda la infraestructura en menos de 30 minutos

---

## ✅ Checklist Pre-Despliegue

- [ ] Dominio registrado en Cloudflare
- [ ] Zone ID de Cloudflare obtenido
- [ ] API Token de Cloudflare creado (`Zone:Edit`, `DNS:Edit`)
- [ ] Repositorio de GitHub con `index.html` en la raíz
- [ ] AWS CLI configurado
- [ ] Terraform >= 1.0 instalado

---

## 🚀 Pasos Rápidos

### **1. Obtener Credenciales**

**Cloudflare Zone ID:**
```
Dashboard → Tu dominio → Esquina inferior derecha
```

**Cloudflare API Token:**
```
https://dash.cloudflare.com/profile/api-tokens
Crear token → Permisos: Zone:Edit, DNS:Edit
```

**GitHub Token:**
```
https://github.com/settings/tokens
Generate new token → Scope: repo
```

### **2. Configurar Variables**

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars
```

### **3. Desplegar**

```powershell
# Inicializar
terraform init

# Route 53
terraform apply -target="module.route53"

# Cloudflare
terraform apply -target="module.cloudflare"

# Esperar DNS (2-3 min)
Start-Sleep -Seconds 180

# Todo lo demás
terraform apply
```

### **4. Migrar a GitHub App**

1. AWS Amplify Console → "Migrate to GitHub App"
2. Autorizar en GitHub
3. Comentar token en `terraform.tfvars`
4. `terraform apply`

### **5. Verificar**

```powershell
terraform output amplify_custom_domain_url
```

---

## ⏱️ Tiempos Estimados

| Paso | Tiempo |
|------|--------|
| Configuración inicial | 5 min |
| Route 53 + Cloudflare | 2 min |
| Propagación DNS | 3 min |
| ACM + Amplify + API | 10-15 min |
| GitHub App | 2 min |
| **Total** | **~25-30 min** |

---

## 🆘 Errores Comunes

**Certificate timeout**
```powershell
Start-Sleep -Seconds 600
terraform apply
```

**GitHub token invalid**
→ Verifica scope `repo`

**Amplify build failed**  
→ Verifica `index.html` en raíz

**Dominio no carga**
→ Espera 15 min para Amplify
