from django.test import TestCase
from .models import Quotes

# Create your tests here.


class QuotesTestsCase(TestCase):
    def setUp(self):
        self.quote = Quotes.objects.create(
            quote="Life is what happens when you're busy making other plans.",
            author="John Lennon",
        )

    def test_create_quote(self):
        # Prueba para crear una cita
        new_quote = Quotes.objects.create(
            quote="Be yourself; everyone else is already taken.",
            author="Oscar Wilde"
        )
        self.assertEqual(new_quote.quote, "Be yourself; everyone else is already taken.")
        self.assertEqual(new_quote.author, "Oscar Wilde")

    def test_retrieve_quote(self):
        # Prueba para leer/recuperar una cita
        quote = Quotes.objects.get(id=self.quote.id)
        self.assertEqual(quote.quote, "Life is what happens when you're busy making other plans.")
        self.assertEqual(quote.author, "John Lennon")

    def test_update_quote(self):
        # Prueba para actualizar una cita
        self.quote.quote = "Updated quote text."
        self.quote.save()
        updated_quote = Quotes.objects.get(id=self.quote.id)
        self.assertEqual(updated_quote.quote, "Updated quote text.")

    def test_delete_quote(self):
        # Prueba para eliminar una cita
        quote_id = self.quote.id
        self.quote.delete()
        with self.assertRaises(Quotes.DoesNotExist):
            Quotes.objects.get(id=quote_id)
