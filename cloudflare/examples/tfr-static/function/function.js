export default {
    async fetch(request, env, ctx) {
        const url = new URL(request.url);
        const uri = url.pathname;

        // Make the download URLs compatible with the terraform registry protocol
        if (uri.endsWith('/download')) {
            return new Response(null, {
                status: 204,
                statusText: 'No Content',
                headers: {
                    'X-Terraform-Get': './module.tar.gz'
                }
            });
        }

        // Root path rewrite
        if (uri === '/') {
            url.pathname = '/index.html';
            return fetch(url, request);
        }

        // Directory index rewrite
        if (uri.endsWith('/')) {
            url.pathname = uri + 'index.html';
            return fetch(url, request);
        }

        // Trailing slash redirects
        const lastSegment = uri.substring(uri.lastIndexOf('/') + 1);
        if (!lastSegment.includes('.') && !uri.endsWith('/versions')) {
            return Response.redirect(`${url.origin}${uri}/`, 301);
        }

        return fetch(request);
    }
};
