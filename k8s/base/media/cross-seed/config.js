// Note: Cross-Seed vars should be escaped with $${VAR_NAME} to avoid interpolation by Flux
module.exports = {
  delay: 20,
  qbittorrentUrl: "http://qbittorrent.media.svc.cluster.local:8080",
  torznab: [
    `http://prowlarr.media.svc.cluster.local/4/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // at
    `http://prowlarr.media.svc.cluster.local/16/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // ant
    `http://prowlarr.media.svc.cluster.local/2/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // blu
    `http://prowlarr.media.svc.cluster.local/1/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // btn
    `http://prowlarr.media.svc.cluster.local/12/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // cz
    `http://prowlarr.media.svc.cluster.local/3/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // hdt
    `http://prowlarr.media.svc.cluster.local/15/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // ipt
    `http://prowlarr.media.svc.cluster.local/5/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // ms
    `http://prowlarr.media.svc.cluster.local/14/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // tl
    `http://prowlarr.media.svc.cluster.local/13/api?apikey=${process.env.PROWLARR_API_KEY}:9696`, // ts
  ],
  port: process.env.CROSSSEED_PORT || 80,
  apiAuth: false,
  action: "inject",
  includeEpisodes: false,
  includeSingleEpisodes: true,
  includeNonVideos: true,
  duplicateCategories: true,
  matchMode: "safe",
  skipRecheck: true,
  linkType: "hardlink",
  linkDir: "/media/Downloads/qbittorrent/complete/cross-seed",
  dataDirs: [
    "/media/Downloads/qbittorrent/complete/prowlarr",
    "/media/Downloads/qbittorrent/complete/radarr",
    "/media/Downloads/qbittorrent/complete/sonarr",
  ],
  maxDataDepth: 1,
  outputDir: "/config/xseeds",
  torrentDir: "/config/qBittorrent/BT_backup",
};
