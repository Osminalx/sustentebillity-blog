export default async function getRandomQuote() {
    const randomNum = Math.floor(Math.random() * (10 - 1 + 1) + 1);
    const url = import.meta.env.PUBLIC_API_BASE_URL;
    try {
        const response = await fetch(url + `/quotes/${randomNum}/`);
        const data = await response.json();
        return {
            quote: data.quote,
            author: data.author,
        };
    } catch (error) {
        console.error(error);
        return {
            quote: 'No se pudo cargar la frase.',
            author: 'Error',
        };
    }
}
