import { test, expect } from '@playwright/test';

test.describe('Navigation and Interaction Tests', () => {
    test('should navigate and interact with various elements', async ({ page }) => {
        // Ir a la página principal
        await page.goto('http://localhost:4321/');

        // Navegar a la página "About"
        await page.getByRole('link', { name: 'About' }).click();
        await expect(page).toHaveURL(/\/About/); // Verificar la URL

        // Interactuar con nombres (estos parecen ser de personas)
        await page.getByText('Osmin Alexander Fregoso Angel osminGod').click();
        await page.getByText('Jesus Adrian Canales Rojas "').click();

        // Interactuar con imágenes específicas
        await page.getByRole('img', { name: 'Foto de Israel Cruz King' }).click();
        await page.getByRole('img', { name: 'Foto de Carlos Sandez Cruz' }).click();

        // Navegar a un enlace llamado "Red-crowned Amazon"
        await page.getByRole('link', { name: 'Red-crowned Amazon' }).click();

        // Interactuar con una lista de elementos (max-w-lg parece un contenedor de items)
        await page.locator('.max-w-lg').first().click();

        // Probar botones de secciones
        await page.getByRole('button', { name: 'Apariencia' }).click();
        await page.getByRole('button', { name: 'Descripcion' }).click();

        // Navegar a la página "Contact"
        await page.getByRole('link', { name: 'Contact' }).click();
        await expect(page).toHaveURL(/\/Contact/);

        // Regresar y seguir interactuando con más secciones
        await page.getByRole('link', { name: 'Red-crowned Amazon' }).click();
        await page.locator('div:nth-child(2) > .max-w-lg').click();
        await page.getByRole('button', { name: 'Distribución' }).click();
        await page.getByRole('button', { name: 'Hábitos y Estilo de Vida' }).click();

        // Interactuar con un artículo y un enlace dentro de él
        await page.getByRole('article').getByRole('link').click();

        // Continuar con más interacciones
        await page.locator('div:nth-child(3) > .max-w-lg').click();
        await page.getByRole('button', { name: 'Población' }).click();
        await page.getByRole('button', { name: 'Datos divertidos' }).click();

        // Finalizar regresando al enlace principal
        await page.getByRole('link', { name: 'Red-crowned Amazon' }).click();
    });
});
