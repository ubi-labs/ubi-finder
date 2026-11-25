export function createPageUrl(pageName: string) {
    const boundary = pageName.search(/[?#]/);
    const pathname = boundary === -1 ? pageName : pageName.slice(0, boundary);
    const suffix = boundary === -1 ? '' : pageName.slice(boundary);
    return '/' + pathname.replace(/ /g, '-').toLowerCase() + suffix;
}

