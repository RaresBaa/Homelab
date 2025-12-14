# Homelab Docker Compose

This repository contains a Docker Compose setup for my personal homelab. It includes various services for media management, network ad-blocking, file sync, downloaders, whiteboards, PDF tools, recipe books, task management and more.

Outside of docker, I have samba shares for easy access to files and tailscale so i can access all services from everywhere.

## Containers

| Container      | Description                                      | Ports                                                                   |
|----------------|--------------------------------------------------|-------------------------------------------------------------------------|
| heimdall       | Web dashboard.                                   | 80, 443                                                                 |
| jellyfin       | Media streaming                                  | 8096, 7359/udp, 1900/udp                                                |
| pihole         | An ad blocker.                                   | 53/tcp, 53/udp, 81                                                      |
| qbittorrent    | Torrent client.                                  | 82, 6881, 6881/udp                                                      |
| syncthing      | File synchronization program.                    | 8384, 22000/tcp, 22000/udp, 21027/udp                                   |
| sonarr         | TV Show collection manager.                      | 8989                                                                    |
| radarr         | Movie collection manager.                        | 7878                                                                    |
| prowlarr       | Indexer for sonarr and radarr.                   | 9696                                                                    |
| bazarr         | Subtitle downloader                              | 6767                                                                    |
| flaresolverr   | Captcha solver for prowlarr.                     | 8191                                                                    |
| jdownloader-2  | Downloader.                                      | 5800                                                                    |
| jellyseerr     | Media discovery and request tool.                | 5055                                                                    |
| portainer      | Management UI for Docker.                        | 8000, 9444, 9000                                                        |
| watchtower     | Docker container updater.                        | -                                                                       |
| excalidraw     | Web whiteboard.                                  | 86                                                                      |
| stirlingpdf    | PDF tools.                                       | 85                                                                      |
| mealie         | Recipe book.                                     | 9925                                                                    |
| prunemate      | Docker container cleaner.                        | 7676                                                                    |
| syncwave       | Kanban board.                                    | 88                                                                      |
| decluttarr     | Deletes stuck, incomplete, etc. torrents.        | -                                                                       |
| searx          | Metasearch engine.                               | 8080                                                                    |

## Scripts

### `updateDNS.sh`

This script updates a DuckDNS dynamic DNS record. It retrieves the current public IP address using `upnpc` and compares it to the last known IP stored in `/tmp/current_ip_duckdns`. If the IP has changed, it updates the DuckDNS record.

This script is run by cron every 30 minutes.

## Setup

Before running `docker-compose up`, you need to create a `.env` file. An example is provided in `.env.example`. This file contains all the necessary environment variables for the containers, such as passwords, API keys, and paths.

## How the ARR stack works

- Prowlarr: indexer that searches certain websites for torrents.
- Flaresolverr: when Prowlarr gets a captcha, it sends it to this container to be solved.
- Qbittorrent: it is a web torrent client.
- Radarr: it uses Prowlarr to search for movie torrents and then sends them to the qbittorrent container to be downloaded, after they are downloaded it moves them to a movie folder.
- Sonarr: it uses Prowlarr to search for TV shows and repeates the process from Radarr.
- Bazarr: this container monitors the movie and tv show folders from Radarr and Sonarr and when new media is detected it searches and downloads the subtitles for it.
- Decluttarr: when torrents get stuck, are incomplete or have other errors, this container deletes them and triggers searches for new ones.
- Jellyseer: convenient web interface where you can see new, popular, simmilar releases for movies and tv shows. from this interface you can request media and it will parsed to Sonarr/Radarr to be downloaded.
- Jellyfin: a container that handles media streaming and transcoding for multiple cliens, for example web interface, smart TV, mobile devices. It monitors the movie and tv show folders, when new media is added, it imports it, downloads stats and cover art for it.

## How this stack works

- Heimdall: is a dashboard where i have the most used websites and tools.
- Pihole: container that handles DNS caching and blocks certain domains, for example ads.
- Qbittorrent: it isn't used exclusively for the arr stack.
- J-downloader2: Downloader with a lot of useful features, for example pause the download or download everything from a website while specifying the file types to be downloaded.
- Syncthing: a program that syncronises files/folders on multiple devices. For example desktop backgrounds or configuration files.
- StirlingPDF: a website that has a lot of PDF tools.
- Mealie: a website used for storing and planning cooking recepies.
- Excalidraw: a website for whiteboards.
- Syncwave: a kanban board used for tasks.
- Searx: it is a search engine that will use multiple search engines for results and aggregates the results.
- The ARR stack mentioned above.

Management part of the stack:

- Portainer: is a graphical UI for docker.
- Watchtower: Automatic updater for containers.
- Prunemate: Removes old containers and unncessary files.
