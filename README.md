# Docker Compose setup for EMS

* Pick/generate a password and BCrypt it.
* Put the hashed password in ems' password.properties. `submitit.redux=#hash`.
* Put the plain text version in cake config and submitit config in property emsPassword.
* Make sure the Cake app is not exposed with out protection. Either put something in front of it or configure Google OAuth.
* Run buildall.sh then docker-compose -f compose/docker-compose.yml up
