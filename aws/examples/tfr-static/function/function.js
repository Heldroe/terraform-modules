function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Don't alter the root path at all
    if (uri === '/') {
        return request;
    }

    // Make the download URLs compatible with the terraform registry protocol
    if (uri.endsWith('/download')) {
        var directory = uri.substring(0, uri.lastIndexOf('/') + 1);
        var moduleUrl = 'https://${registry_domain}' + directory + 'module.tar.gz';

        return {
            statusCode: 204,
            statusDescription: 'No Content',
            headers: {
                'x-terraform-get': { value: moduleUrl }
            }
        };
    }

    // HTML interface: serve directories
    if (uri.endsWith('/')) {
        request.uri = uri + 'index.html';
        return request;
    }

    // HTML interface: add missing trailing slashes
    var lastSegment = uri.substring(uri.lastIndexOf('/') + 1);
    if (lastSegment.indexOf('.') === -1) {
        return {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                'location': { value: uri + '/' }
            }
        };
    }

    return request;
}
