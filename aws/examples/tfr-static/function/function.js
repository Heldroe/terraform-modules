function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Don't alter the root path
    if (uri === '/') return request;

    // Make the download URLs compatible with the terraform registry protocol
    if (uri.endsWith('/download')) {
        return {
            statusCode: 204,
            statusDescription: 'No Content',
            headers: {
                'x-terraform-get': {
                    value: './module.tar.gz'
                }
            }
        };
    }

    // HTML interface: serve directories
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
        return request;
    }

    // HTML interface: add missing trailing slashes
    if (!uri.slice(uri.lastIndexOf('/') + 1).includes('.') && !uri.endsWith('/versions')) {
        return {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                location: { value: uri + '/' }
            }
        };
    }

    return request;
}
