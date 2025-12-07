# Recyclarr Configuration

This document explains how the recyclarr configuration manages quality profiles and custom formats for Sonarr and Radarr.

## Overview

Recyclarr syncs quality profiles and custom formats from [TRaSH Guides](https://trash-guides.info/) to Sonarr and Radarr. The configuration supports both regular media and anime content using a single-instance approach.

**Configuration file:** `k8s/base/media/recyclarr/recyclarr.yml`

## Architecture

### Sonarr (TV Shows)

Sonarr uses **separate profiles** for regular TV and anime:

| Profile | Use Case | Overseerr Routing |
|---------|----------|-------------------|
| `WEB-2160p` | 4K TV shows | Default for 4K requests |
| `WEB-1080p` | 1080p TV shows | Default for HD requests |
| `WEB-480p` | SD TV shows | Fallback/legacy |
| `Remux-1080p - Anime` | Anime series | Route anime requests here |

### Radarr (Movies)

Radarr uses a **single merged profile** for all movies:

| Profile | Use Case |
|---------|----------|
| `SQP-1 (2160p)` | All movies (regular + anime) |

Since Overseerr cannot differentiate anime movies from regular movies, anime custom formats are merged into the same profile. Anime-specific formats only add positive scores when anime attributes are detected, so they don't negatively impact regular movie scoring.

## Quality Preferences

### Resolution Priority

The configuration enforces **native resolution only** - upscaled content is heavily penalized:

```
Native 4K > Native 1080p > Native 720p > Native 480p
```

Upscaled releases receive a `-10000` score penalty, causing them to rank below native lower-resolution releases.

### Scoring Hierarchy

| Custom Format | Score | Purpose |
|---------------|-------|---------|
| **Upscaled** | -10000 | Prevents grabbing upscaled content |
| TrueHD ATMOS | +5000 | Highest audio quality preference |
| DD+ ATMOS | +3000 | Strong Dolby Atmos preference |
| HDR10+ Boost | +1000 | Preferred HDR format |
| Dolby Vision Boost | +100 | Secondary HDR preference |
| Uncensored (anime) | +101 | Prefer uncensored anime releases |
| 10bit (anime) | +101 | Prefer 10-bit color depth |
| Anime Dual Audio | +10 | Slight preference for JP + EN audio |

### Unwanted Content

The following release types receive negative scores across all profiles:
- Bad Dual Groups
- No-RlsGroup
- Obfuscated
- Retags
- Scene releases

## Anime-Specific Configuration

### Sonarr Anime

The `Remux-1080p - Anime` profile uses:
- **SeaDex group rankings**: Anime BD Tier 01-08 for quality prioritization
- **Upgrades**: Allowed up to Bluray-1080p quality with max score 10000
- **Anime formats**: Uncensored (+101), 10bit (+101), Dual Audio (+10)
- **HDR/Atmos boosts**: Same as regular profiles

### Radarr Anime

Anime movies use the same `SQP-1 (2160p)` profile with additional anime custom formats:
- Uncensored: +101
- 10bit: +101
- Anime Dual Audio: +10

These formats only trigger on anime releases and don't affect regular movie scoring.

## Overseerr Integration

### Routing Anime Series

In Overseerr, configure anime series requests to use the `Remux-1080p - Anime` quality profile:

1. Go to **Settings > Sonarr**
2. Under your Sonarr server, find **Quality Profile**
3. For anime requests, select `Remux-1080p - Anime`

Alternatively, use Overseerr's genre-based or keyword-based routing if available.

### Movie Requests

All movie requests (anime and regular) automatically use `SQP-1 (2160p)`. No special configuration needed.

## Templates Used

### Sonarr Templates

```yaml
- template: sonarr-quality-definition-series
- template: sonarr-v4-quality-profile-web-2160p
- template: sonarr-v4-custom-formats-web-2160p
- template: sonarr-v4-quality-profile-web-1080p
- template: sonarr-v4-custom-formats-web-1080p
- template: sonarr-v4-quality-profile-anime
- template: sonarr-v4-custom-formats-anime
```

### Radarr Templates

```yaml
- template: radarr-quality-definition-sqp-streaming
- template: radarr-quality-profile-sqp-1-2160p-default
- template: radarr-custom-formats-sqp-1-2160p
```

## Trash IDs Reference

### Upscale Prevention

| App | Trash ID | Format |
|-----|----------|--------|
| Sonarr | `23297a736ca77c0fc8e70f8edd7ee56c` | Upscaled |
| Radarr | `bfd8eb01832d646a0a89c4deb46f8564` | Upscaled |

### Anime Custom Formats (Sonarr)

| Trash ID | Format |
|----------|--------|
| `026d5aadd1a6b4e550b134cb6c72b3ca` | Uncensored |
| `b2550eb333d27b75833e25b8c2557b38` | 10bit |
| `418f50b10f1907201b6cfdf881f467b7` | Anime Dual Audio |

### Anime Custom Formats (Radarr)

| Trash ID | Format |
|----------|--------|
| `064af5f084a0a24458cc8ecd3220f93f` | Uncensored |
| `a5d148168c4506b55cf53984107c396e` | 10bit |
| `4a3b087eea2ce012fcc1ce319259a3be` | Anime Dual Audio |

## Troubleshooting

### Recyclarr Sync Errors

**"Custom Format does not exist in the guide"**
- Verify the trash_id is correct for the specific app (Sonarr vs Radarr IDs differ)
- Check [TRaSH Guides](https://trash-guides.info/) for current IDs

**"UNIQUE constraint failed: CustomFormats.Name"**
- A custom format with the same name already exists
- Remove conflicting template includes or use `delete_old_custom_formats: true`

## References

- [TRaSH Guides - Sonarr](https://trash-guides.info/Sonarr/)
- [TRaSH Guides - Radarr](https://trash-guides.info/Radarr/)
- [TRaSH Guides - Anime Sonarr](https://trash-guides.info/Sonarr/sonarr-setup-quality-profiles-anime/)
- [TRaSH Guides - Anime Radarr](https://trash-guides.info/Radarr/radarr-setup-quality-profiles-anime/)
- [Recyclarr Documentation](https://recyclarr.dev/)
- [Recyclarr Config Templates](https://github.com/recyclarr/config-templates)
