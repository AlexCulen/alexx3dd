# Alex3D — tienda y panel de administración

Plantilla de tienda inspirada en el video de referencia: estética oscura, acentos rojos, productos destacados, filtros, carrito y contacto por WhatsApp. Incluye un panel `admin.html` para gestionar catálogo y fotos.

## Importante: GitHub Pages no es un backend
GitHub Pages publica HTML/CSS/JS estáticos. No puede guardar de forma segura un usuario/contraseña propia ni escribir archivos del repositorio desde el navegador. Por eso este proyecto usa Supabase para autenticación, base de datos y almacenamiento de imágenes. No se necesita un token de GitHub en el sitio.

## Configuración
1. Creá un proyecto en https://supabase.com/.
2. En Supabase, abrí **SQL Editor**, pegá el contenido de `supabase.sql` y ejecutalo.
3. En **Project Settings → API** copiá la **Project URL** y la **publishable/anon key**.
4. Pegá esos valores en `config.js` en `SUPABASE_URL` y `SUPABASE_ANON_KEY`. Nunca uses `service_role`/secret key.
5. En **Authentication → Users**, creá el usuario administrador con el email y contraseña que elijas. Desactivá el registro público de usuarios en Authentication settings para que desconocidos no creen cuentas. La política SQL permite administrar a usuarios autenticados; mantené un solo usuario admin y no compartas sus credenciales.
6. Para probar, serví los archivos con un servidor local (por ejemplo la extensión Live Server de VS Code). Abrir HTML como `file://` puede dar problemas con solicitudes externas.
7. Subí los archivos a un repositorio GitHub.
8. En GitHub: **Settings → Pages → Deploy from a branch → main → /(root) → Save**.
9. Entrá a `https://TU-USUARIO.github.io/TU-REPOSITORIO/` para la tienda y a `https://TU-USUARIO.github.io/TU-REPOSITORIO/admin.html` para administrar.
10. En `config.js`, cambiá `WHATSAPP_NUMBER` por tu número en formato internacional, solo números (Argentina suele comenzar con 549).

## Uso del administrador
- Ingresá en `admin.html` con el usuario creado en Supabase.
- Podés agregar, editar, publicar/ocultar y borrar productos.
- Subí fotos JPG, PNG, WEBP o GIF de hasta 5 MB.
- Los cambios se guardan en Supabase y se reflejan en la tienda.

## Límites y seguridad
- El usuario administrador no está codificado en el HTML: la sesión la gestiona Supabase Auth.
- La clave `anon/publishable` se usa en frontend y no es un secreto; la seguridad depende de RLS y las políticas de Storage.
- Este SQL concede administración a cualquier usuario autenticado. Para una tienda real, deshabilitá el registro público y creá solo usuarios administradores confiables. Para múltiples roles, agregá una tabla de roles y políticas que validen el rol de administrador.
- La tienda es un punto de partida; no procesa pagos. El carrito genera un pedido por WhatsApp.
- Las imágenes de demostración son marcadores visuales. Cargá tus fotos reales desde el panel.
- GitHub Pages publica el código fuente: nunca pongas tokens personales de GitHub, contraseñas ni claves secretas en `config.js`.
