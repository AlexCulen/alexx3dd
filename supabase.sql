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


-- Galería de múltiples fotos y videos por producto. Ejecutar también si ya habías creado las tablas.
create table if not exists public.product_media (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  url text not null,
  media_type text not null check (media_type in ('image','video')),
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);
alter table public.product_media enable row level security;
drop policy if exists "Public can read media for active products" on public.product_media;
create policy "Public can read media for active products" on public.product_media for select to anon, authenticated using (exists (select 1 from public.products p where p.id = product_id and p.active = true));
drop policy if exists "Authenticated admins manage product media" on public.product_media;
create policy "Authenticated admins manage product media" on public.product_media for all to authenticated using (auth.uid() is not null) with check (auth.uid() is not null);
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('product-media','product-media',true,104857600,array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm','video/ogg'])
on conflict (id) do update set public=true,file_size_limit=104857600,allowed_mime_types=array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm','video/ogg'];
drop policy if exists "Public read product media files" on storage.objects;
create policy "Public read product media files" on storage.objects for select to anon, authenticated using (bucket_id = 'product-media');
drop policy if exists "Authenticated upload product media files" on storage.objects;
create policy "Authenticated upload product media files" on storage.objects for insert to authenticated with check (bucket_id = 'product-media');
drop policy if exists "Authenticated update product media files" on storage.objects;
create policy "Authenticated update product media files" on storage.objects for update to authenticated using (bucket_id = 'product-media') with check (bucket_id = 'product-media');
drop policy if exists "Authenticated delete product media files" on storage.objects;
create policy "Authenticated delete product media files" on storage.objects for delete to authenticated using (bucket_id = 'product-media');
