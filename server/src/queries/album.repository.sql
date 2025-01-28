-- NOTE: This file is auto generated by ./sql-generator

-- AlbumRepository.getById
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks",
  (
    select
      json_agg("asset") as "assets"
    from
      (
        select
          "assets".*,
          "exif" as "exifInfo"
        from
          "assets"
          inner join "exif" on "assets"."id" = "exif"."assetId"
          inner join "albums_assets_assets" on "albums_assets_assets"."assetsId" = "assets"."id"
        where
          "albums_assets_assets"."albumsId" = "albums"."id"
          and "assets"."deletedAt" is null
        order by
          "assets"."fileCreatedAt" desc
      ) as "asset"
  ) as "assets"
from
  "albums"
where
  "albums"."id" = $1
  and "albums"."deletedAt" is null

-- AlbumRepository.getByAssetId
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers"
from
  "albums"
  inner join "albums_assets_assets" as "album_assets" on "album_assets"."albumsId" = "albums"."id"
where
  (
    "albums"."ownerId" = $1
    or exists (
      select
      from
        "albums_shared_users_users" as "album_users"
      where
        "album_users"."albumsId" = "albums"."id"
        and "album_users"."usersId" = $2
    )
  )
  and "album_assets"."assetsId" = $3
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc,
  "albums"."createdAt" desc

-- AlbumRepository.getMetadataForIds
select
  "albums"."id" as "albumId",
  min("assets"."fileCreatedAt") as "startDate",
  max("assets"."fileCreatedAt") as "endDate",
  count("assets"."id")::int as "assetCount"
from
  "albums"
  inner join "albums_assets_assets" as "album_assets" on "album_assets"."albumsId" = "albums"."id"
  inner join "assets" on "assets"."id" = "album_assets"."assetsId"
where
  "albums"."id" in ($1)
  and "assets"."deletedAt" is null
group by
  "albums"."id"

-- AlbumRepository.getOwned
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
where
  "albums"."ownerId" = $1
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc

-- AlbumRepository.getShared
select
  "albums".*,
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
where
  (
    exists (
      select
      from
        "albums_shared_users_users" as "album_users"
      where
        "album_users"."albumsId" = "albums"."id"
        and (
          "albums"."ownerId" = $1
          or "album_users"."usersId" = $2
        )
    )
    or exists (
      select
      from
        "shared_links"
      where
        "shared_links"."albumId" = "albums"."id"
        and "shared_links"."userId" = $3
    )
  )
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc

-- AlbumRepository.getNotShared
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner"
from
  "albums"
where
  "albums"."ownerId" = $1
  and "albums"."deletedAt" is null
  and not exists (
    select
    from
      "albums_shared_users_users" as "album_users"
    where
      "album_users"."albumsId" = "albums"."id"
  )
  and not exists (
    select
    from
      "shared_links"
    where
      "shared_links"."albumId" = "albums"."id"
  )
order by
  "albums"."createdAt" desc

-- AlbumRepository.getAssetIds
select
  *
from
  "albums_assets_assets"
where
  "albums_assets_assets"."albumsId" = $1
  and "albums_assets_assets"."assetsId" in ($2)
