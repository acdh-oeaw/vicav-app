@echo off
for %%f in (node_modules\bootstrap\dist\js\bootstrap.js node_modules\bootstrap\dist\js\bootstrap.min.js) do copy %%f js
for %%f in (node_modules\jquery\dist\jquery.js node_modules\jquery\dist\jquery.min.js node_modules\jquery\dist\jquery.min.map) do copy %%f js
cd node_modules\jquery-ui
del /s /q dist
cmd /c "npm install"
cmd /c "node_modules\.bin\grunt concat:css requirejs uglify"
cd ..\..
for %%f in (node_modules\jquery-ui\dist\jquery-ui.js node_modules\jquery-ui\dist\jquery-ui.min.js) do copy %%f js
copy node_modules\leaflet\dist\leaflet.css vendor
for %%f in (node_modules\leaflet\dist\leaflet.js node_modules\leaflet\dist\leaflet.js.map) do copy %%f js
for %%f in (node_modules\popper.js\dist\umd\popper.js node_modules\popper.js\dist\umd\popper.js.map) do copy %%f js
for %%f in (node_modules\popper.js\dist\umd\popper.min.js node_modules\popper.js\dist\umd\popper.min.js.map) do copy %%f js

