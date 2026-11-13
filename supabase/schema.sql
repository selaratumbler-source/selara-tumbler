create extension if not exists pgcrypto;

create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  slug text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category_id uuid references categories(id),
  description text,
  price int not null check (price >= 0),
  cost_price int not null check (cost_price >= 0),
  sizes text[] not null default '{}',
  colors text[] not null default '{}',
  can_custom boolean not null default true,
  custom_fee int not null default 15000,
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists suppliers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  contact text,
  address text,
  shipping_cost int not null default 0,
  can_custom boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  buyer_name text,
  buyer_wa text,
  status text not null default 'Menunggu Konfirmasi' check (status in ('Menunggu Konfirmasi','Dibelanjakan','Barang Datang','Selesai')),
  total int not null default 0,
  source text not null default 'WA',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  product_id uuid references products(id),
  product_name text not null,
  color text,
  size text,
  qty int not null default 1 check (qty > 0),
  price int not null,
  custom_name text,
  custom_fee int not null default 0,
  subtotal int not null
);

alter table order_items add column if not exists cost_price int not null default 0;

create table if not exists settings (
  id int primary key default 1 check (id = 1),
  store_name text not null default 'Selara Tumbler',
  wa_number text,
  custom_fee_default int not null default 15000
);

create table if not exists admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.admin_users where user_id = auth.uid());
$$;
revoke all on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

create or replace function public.current_user_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.is_admin();
$$;
revoke all on function public.current_user_is_admin() from public, anon;
grant execute on function public.current_user_is_admin() to authenticated;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_set_updated_at on products;
create trigger products_set_updated_at before update on products for each row execute function public.set_updated_at();
drop trigger if exists orders_set_updated_at on orders;
create trigger orders_set_updated_at before update on orders for each row execute function public.set_updated_at();

alter table categories enable row level security;
alter table products enable row level security;
alter table suppliers enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;
alter table settings enable row level security;
alter table admin_users enable row level security;

-- Public clients read products through this view only; cost_price is deliberately omitted.
create or replace view public.products_public as
select p.id, p.name, p.category_id, c.name as category_name, p.description, p.price,
       p.sizes, p.colors, p.can_custom, p.custom_fee, p.image_url, p.is_active,
       p.created_at, p.updated_at
from public.products p
join public.categories c on c.id = p.category_id
where p.is_active = true;

drop policy if exists "public read categories" on categories;
create policy "public read categories" on categories for select using (true);
drop policy if exists "admin manage categories" on categories;
create policy "admin manage categories" on categories for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin manage products" on products;
create policy "admin manage products" on products for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin manage suppliers" on suppliers;
create policy "admin manage suppliers" on suppliers for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin manage orders" on orders;
create policy "admin manage orders" on orders for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin manage order_items" on order_items;
create policy "admin manage order_items" on order_items for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin manage settings" on settings;
create policy "admin manage settings" on settings for all to authenticated using (public.is_admin()) with check (public.is_admin());

revoke all on public.products, public.suppliers, public.orders, public.order_items, public.settings, public.admin_users from anon, authenticated;
revoke all on public.categories from anon, authenticated;
grant select on public.categories to anon, authenticated;
grant select on public.products_public to anon, authenticated;
grant select, insert, update, delete on public.categories, public.products, public.suppliers, public.orders, public.order_items, public.settings to authenticated;

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "public read product images" on storage.objects;
create policy "public read product images" on storage.objects for select using (bucket_id = 'product-images');
drop policy if exists "admin upload product images" on storage.objects;
create policy "admin upload product images" on storage.objects for insert to authenticated with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "admin update product images" on storage.objects;
create policy "admin update product images" on storage.objects for update to authenticated using (bucket_id = 'product-images' and public.is_admin()) with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "admin delete product images" on storage.objects;
create policy "admin delete product images" on storage.objects for delete to authenticated using (bucket_id = 'product-images' and public.is_admin());


