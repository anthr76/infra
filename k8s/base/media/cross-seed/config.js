// Note: Cross-Seed vars should be escaped with $${VAR_NAME} to avoid interpolation by Flux
module.exports = {
  delay: 20,
  qbittorrentUrl: "http://qbittorrent.media.svc.cluster.local:8080",
  torznab: [
    `http://prowlarr.media.svc.cluster.local:9696/4/api?apikey=${process.env.PROWLARR_API_KEY}`, // at
    `http://prowlarr.media.svc.cluster.local:9696/16/api?apikey=${process.env.PROWLARR_API_KEY}`, // ant
    `http://prowlarr.media.svc.cluster.local:9696/2/api?apikey=${process.env.PROWLARR_API_KEY}`, // blu
    `http://prowlarr.media.svc.cluster.local:9696/1/api?apikey=${process.env.PROWLARR_API_KEY}`, // btn
    `http://prowlarr.media.svc.cluster.local:9696/12/api?apikey=${process.env.PROWLARR_API_KEY}`, // cz
    `http://prowlarr.media.svc.cluster.local:9696/3/api?apikey=${process.env.PROWLARR_API_KEY}`, // hdt
    `http://prowlarr.media.svc.cluster.local:9696/15/api?apikey=${process.env.PROWLARR_API_KEY}`, // ipt
    `http://prowlarr.media.svc.cluster.local:9696/5/api?apikey=${process.env.PROWLARR_API_KEY}`, // ms
    `http://prowlarr.media.svc.cluster.local:9696/14/api?apikey=${process.env.PROWLARR_API_KEY}`, // tl
    `http://prowlarr.media.svc.cluster.local:9696/13/api?apikey=${process.env.PROWLARR_API_KEY}`, // ts
    `http://prowlarr.media.svc.cluster.local:9696/49/api?apikey=${process.env.PROWLARR_API_KEY}`, // bt
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
