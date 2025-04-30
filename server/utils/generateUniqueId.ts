function generateUniqueId(IDs: string[]): string {
    let id;

    do {
        id = Math.random().toString(36);
    } while (IDs.includes(id))

    return id
}

export default generateUniqueId