resource "cloudflare_authenticated_origin_pulls" "int_auth_origin" {
  zone_id = data.sops_file.tf_secrets.data["int_zone_id"]
  enabled = false
}

resource "cloudflare_zone_settings_override" "int_cf_settings" {
    zone_id = data.sops_file.tf_secrets.data["int_zone_id"]
    settings {
        brotli = "on"
        challenge_ttl = 2700
        security_level = "high"
        opportunistic_encryption = "off"
        automatic_https_rewrites = "off"
        always_online = "on"
        browser_check = "on"
        mirage = "on"
        waf = "off"
        ipv6 = "on"
        always_use_https = "off"
        min_tls_version = "1.0"
        universal_ssl = "off"
        ssl = "off"
        development_mode = "off"
        email_obfuscation = "on"
        hotlink_protection = "on"
        ip_geolocation = "on"
        opportunistic_onion = "on"
        origin_error_page_pass_thru = "on"
        prefetch_preload = "on"
        privacy_pass = "on"
        rocket_loader = "on"
        server_side_exclude = "on"
        sort_query_string_for_cache = "on"
        tls_client_auth = "off"
        true_client_ip_header = "off"
        webp = "off"
        websockets = "off"
        zero_rtt = "off"
        tls_1_3 = "off"
        minify {
            css = "on"
            js = "on"
            html = "on"
        }
        security_header {
            enabled = true
        }
    }
}
