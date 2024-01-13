// Note: Cross-Seed vars should be escaped with $${VAR_NAME} to avoid interpolation by Flux
module.exports = {
  delay: 20,
  qbittorrentUrl: "http://qbittorrent.media.svc.cluster.local:8080",
  torznab: [
    `http://prowlarr.default.svc.cluster.local:8080/4/api?apikey=${process.env.PROWLARR_API_KEY}`, // at
    `http://prowlarr.default.svc.cluster.local:8080/16/api?apikey=${process.env.PROWLARR_API_KEY}`, // ant
    `http://prowlarr.default.svc.cluster.local:8080/2/api?apikey=${process.env.PROWLARR_API_KEY}`, // blu
    `http://prowlarr.default.svc.cluster.local:8080/1/api?apikey=${process.env.PROWLARR_API_KEY}`, // btn
    `http://prowlarr.default.svc.cluster.local:8080/12/api?apikey=${process.env.PROWLARR_API_KEY}`, // cz
    `http://prowlarr.default.svc.cluster.local:8080/3/api?apikey=${process.env.PROWLARR_API_KEY}`, // hdt
    `http://prowlarr.default.svc.cluster.local:8080/15/api?apikey=${process.env.PROWLARR_API_KEY}`, // ipt
    `http://prowlarr.default.svc.cluster.local:8080/5/api?apikey=${process.env.PROWLARR_API_KEY}`, // ms
    `http://prowlarr.default.svc.cluster.local:8080/14/api?apikey=${process.env.PROWLARR_API_KEY}`, // tl
    `http://prowlarr.default.svc.cluster.local:8080/13/api?apikey=${process.env.PROWLARR_API_KEY}`, // ts
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
