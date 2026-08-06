async function handleRequest(event) {
    const { request } = event;
    const urlInfo = new URL(request.url);

    const target = urlInfo.searchParams.get('url');

    console.log('url: ', target);

    if (target === null) {
        return new Response(null, { status: 400 });
    }

    const proxyUrlInfo = new URL(target);

    const proxyRequest = new Request(target, {
        method: request.method,
        body: request.body,
        headers: request.headers,
        copyHeaders: true,
    });
    proxyRequest.headers.set('Host', proxyUrlInfo.host);
    // 目标服务器会校验 Origin 头，把客户端的 Origin（edge function 域）转发出去会触发
    // "Invalid Origin Header" 403。重写为目标站自身域名，或干脆删除该头。
    proxyRequest.headers.delete('Origin');
    proxyRequest.headers.set('Origin', proxyUrlInfo.origin);
    // 目标服务器还会校验 Referer 头，删除客户端的 Referer 以避免 "Invalid referer Header" 403。
    proxyRequest.headers.delete('Referer');

    // fetch 反向代理
    const response = await fetch(proxyRequest);

    /** 添加自定义响应头 **/
    // 指定哪些源（origin）允许访问资源
    response.headers.set('Access-Control-Allow-Origin', '*');
    // 指定哪些 HTTP 方法（如 GET, POST 等）允许访问资源
    response.headers.set('Access-Control-Allow-Methods', '*');
    // 指定了哪些 HTTP 头可以在正式请求头中出现
    response.headers.set('Access-Control-Allow-Headers', '*');
    // 预检请求的结果可以被缓存多久
    response.headers.set('Access-Control-Max-Age', '86400');

    /** 删除响应头 **/
    response.headers.delete('X-Cache');

    // 如果有 OPTIONS 预检请求，直接返回 204
    if (request.method === 'OPTIONS') {
        return new Response(null, { headers: response.headers, status: 204 })
    }

    return response;
}

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event));
});