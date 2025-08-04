#
# BDC QGIS Plugins.
# Copyright (C) 2025 INPE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.
#
# Build image with:
#
# docker build -t bdc_qgis_plugins/qgis:3.42 .
#

ARG QGIS_RELEASE=3.42
FROM qgis/qgis:${QGIS_RELEASE}

ADD wtss_plugin.zip .
ADD wlts_plugin.zip .
ADD WCPMS.zip .

RUN apt-get update && \
    apt-get install -y unzip

RUN unzip wtss_plugin.zip -d \
    /usr/share/qgis/python/plugins/
RUN unzip wlts_plugin.zip -d \
    /usr/share/qgis/python/plugins/
RUN unzip WCPMS.zip -d \
    /usr/share/qgis/python/plugins/

RUN python3 -m pip install --user -r \
      /usr/share/qgis/python/plugins/wtss_plugin/requirements.txt \
      --break-system-packages
RUN python3 -m pip install --user -r \
      /usr/share/qgis/python/plugins/wlts_plugin/requirements.txt \
      --break-system-packages
RUN python3 -m pip install --user -r \
      /usr/share/qgis/python/plugins/WCPMS/requirements.txt \
      --break-system-packages

RUN mkdir -p ~/.local/share/QGIS/QGIS3/profiles/default/QGIS

RUN echo -e "\n[PythonPlugins]\nwtss_plugin=true\nwlts_plugin=true\nWCPMS=true\n" \
      >> ~/.local/share/QGIS/QGIS3/profiles/default/QGIS/QGIS3.ini

CMD /bin/bash
