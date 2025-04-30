interface WSResponse {
    code: number,
    message: string
}

const SuccessResponses: { [key: string]: WSResponse } = {
    SUCCESSFULL_CONNECTION: {
        code: 452,
        message: "Connected successfully"
    },

    CLOSED_GRACEFULLY: {
        code: 208,
        message: "Client closed gracefully"
    }
}

export { SuccessResponses }