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
        ipv6 = "on"
        always_use_https = "off"
        min_tls_version = "1.1"
        universal_ssl = "off"
        ssl = "off"
        development_mode = "off"
        email_obfuscation = "on"
        hotlink_protection = "on"
        ip_geolocation = "on"
        opportunistic_onion = "on"
        privacy_pass = "on"
        rocket_loader = "on"
        server_side_exclude = "on"
        tls_client_auth = "off"
        websockets = "off"
        tls_1_3 = "zrt"
        minify {
            css = "on"
            js = "on"
            html = "on"
        }
        security_header {
            enabled = false
        }
    }
}
