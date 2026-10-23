-- Ejecutar en Supabase > SQL Editor.
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null default 'Otros',
  price numeric(12,2) not null default 0 check (price >= 0),
  description text not null default '',
  image_url text,
  featured boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
alter table public.products enable row level security;
-- El público solo puede ver productos publicados.
drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products" on public.products for select to anon, authenticated using (active = true);
-- Los usuarios autenticados pueden administrar el catálogo. Crear solo el usuario admin que vos controles.
drop policy if exists "Authenticated admins manage products" on public.products;
create policy "Authenticated admins manage products" on public.products for all to authenticated using (auth.uid() is not null) with check (auth.uid() is not null);
-- Storage para imágenes de productos.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('product-images','product-images',true,5242880,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public=true,file_size_limit=5242880;
drop policy if exists "Public read product images" on storage.objects;
create policy "Public read product images" on storage.objects for select to anon, authenticated using (bucket_id = 'product-images');
drop policy if exists "Authenticated upload product images" on storage.objects;
create policy "Authenticated upload product images" on storage.objects for insert to authenticated with check (bucket_id = 'product-images');
drop policy if exists "Authenticated update product images" on storage.objects;
create policy "Authenticated update product images" on storage.objects for update to authenticated using (bucket_id = 'product-images') with check (bucket_id = 'product-images');
drop policy if exists "Authenticated delete product images" on storage.objects;
create policy "Authenticated delete product images" on storage.objects for delete to authenticated using (bucket_id = 'product-images');
