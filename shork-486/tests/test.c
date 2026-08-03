#include <curl/curl.h>
#include <stdio.h>

int main(void)
{
    curl_global_init(CURL_GLOBAL_DEFAULT);

    CURL *curl = curl_easy_init();
    if (!curl)
    {
        printf("ERROR: curl_easy_init()\n");
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, "https://sharktastica.co.uk");
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);

    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK)
        printf("ERROR: curl_easy_perform(): %s\n", curl_easy_strerror(res));

    curl_easy_cleanup(curl);
    curl_global_cleanup();
    return 0;
}
