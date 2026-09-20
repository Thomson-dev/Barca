-- Posts and post-media policies for authenticated users.

alter table public.posts enable row level security;

 drop policy if exists "Authenticated users can read posts" on public.posts;
 drop policy if exists "Users can create their own posts" on public.posts;
 drop policy if exists "Users can update their own posts" on public.posts;
 drop policy if exists "Users can delete their own posts" on public.posts;

create policy "Authenticated users can read posts"
on public.posts
for select
to authenticated
using (true);

create policy "Users can create their own posts"
on public.posts
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their own posts"
on public.posts
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete their own posts"
on public.posts
for delete
to authenticated
using ((select auth.uid()) = user_id);

-- The first folder in each storage path must be the authenticated user's id.
insert into storage.buckets (id, name, public)
values ('post-media', 'post-media', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "Users can upload their own post media" on storage.objects;
drop policy if exists "Anyone can read post media" on storage.objects;
drop policy if exists "Users can update their own post media" on storage.objects;
drop policy if exists "Users can delete their own post media" on storage.objects;

create policy "Users can upload their own post media"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'post-media'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "Anyone can read post media"
on storage.objects
for select
to public
using (bucket_id = 'post-media');

create policy "Users can update their own post media"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'post-media'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
)
with check (
  bucket_id = 'post-media'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "Users can delete their own post media"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'post-media'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);
