# Release VICAV

## Release data

First, do `git pull`  
Create a tag in [vicav-content](https://github.com/acdh-oeaw/vicav-content) using ISO date. In VS Code, click on the three dots next to `Source control`, choose `Tags` -> `Create tag...`, enter the date as the name and optionally a description.
Then, do `git push` and `git push origin --tags`

## Release app

Check that the `devel` branch is working:

- https://vicav-dev.acdh.oeaw.ac.at open one item from every entry on the main menu, check for broken pictures, empty cells and missing texts. If something doesn't work, check if it's a known problem on https://vicav.acdh.oeaw.ac.at
- https://vicav-vue.acdh-ch-dev.oeaw.ac.at/ do the same as above

Checkout `master` branch, merge `devel` branch and tag with the new version, e.g. `v3.1.9`  
Then, do `git push` and `git push origin --tags`.  
Checkout `devel` branch, merge `master` branch.
