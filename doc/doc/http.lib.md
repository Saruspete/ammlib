
* [function ammHttp::_OptParse {](#function-ammhttpoptparse-)
* [function ammHttp::Get {](#function-ammhttpget-)
* [function ammHttp::Fetch {](#function-ammhttpfetch-)
* [function ammHttp::GithubReleaseList {](#function-ammhttpgithubreleaselist-)


## function ammHttp::_OptParse {

 Parse incoming options and remove

## function ammHttp::Get {

 Do a single HTTP GET request

## function ammHttp::Fetch {

 Fetch an url

### Arguments

* $1 
* **$2** ((path)):  Directory
* **$3** ((string)): Options to change function behavir. Default: "follow silent"

## function ammHttp::GithubReleaseList {

 List all available releases

### Arguments

*  $1 (string) project path, in format "username/reponame"
*  $2 (bool) show also pre-releases

### Output on stdout

*   one result per line:  tag  publicationTS  name

