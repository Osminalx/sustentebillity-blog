from rest_framework.test import APITestCase, APIClient
from django.contrib.auth.models import User
from rest_framework import status
from .serializers import QuoteSerializer
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
            quote="Be yourself; everyone else is already taken.", author="Oscar Wilde"
        )
        self.assertEqual(
            new_quote.quote, "Be yourself; everyone else is already taken."
        )
        self.assertEqual(new_quote.author, "Oscar Wilde")

    def test_retrieve_quote(self):
        # Prueba para leer/recuperar una cita
        quote = Quotes.objects.get(id=self.quote.id)
        self.assertEqual(
            quote.quote, "Life is what happens when you're busy making other plans."
        )
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


class QuoteViewSetTestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username="testuser", password="testpassword"
        )
        self.client.login(username="testuser", password="testpassword")
        self.quote = Quotes.objects.create(
            quote="Life is what happens when you're busy making other plans.",
            author="John Lennon",
        )
        self.valid_payload = {
            "quote": "Be yourself; everyone else is already taken.",
            "author": "Oscar Wilde",
        }
        self.invalid_payload = {
            "quote": "",
            "author": "",
        }
    
    def test_create_quote(self):

        # Prueba para crear una nueva cita
        response = self.client.post("/quotes/", self.valid_payload, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data["quote"], self.valid_payload["quote"])
        self.assertEqual(response.data["author"], self.valid_payload["author"])

    def test_list_quotes(self):
        # Prueba para listar todas las citas
        response = self.client.get("/quotes/", format="json")
        quotes = Quotes.objects.all()
        serializer = QuoteSerializer(quotes, many=True)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, serializer.data)

    def test_retrieve_quote(self):
        # Prueba para recuperar una cita específica
        response = self.client.get(f"/quotes/{self.quote.id}/", format="json")
        serializer = QuoteSerializer(self.quote)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, serializer.data)

    def test_update_quote(self):
        # Prueba para actualizar una cita
        updated_payload = {
            "quote": "Updated quote text.",
            "author": "John Lennon",
        }
        response = self.client.put(
            f"/quotes/{self.quote.id}/", updated_payload, format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["quote"], updated_payload["quote"])

    def test_partial_update_quote(self):
        # Prueba para una actualización parcial
        partial_payload = {
            "quote": "Partially updated quote text.",
        }
        response = self.client.patch(
            f"/quotes/{self.quote.id}/", partial_payload, format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["quote"], partial_payload["quote"])

    def test_delete_quote(self):
        # Prueba para eliminar una cita
        response = self.client.delete(f"/quotes/{self.quote.id}/", format="json")
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Quotes.objects.filter(id=self.quote.id).exists())

    def test_invalid_create_quote(self):
        # Prueba para un intento de creación con datos inválidos
        response = self.client.post("/quotes/", self.invalid_payload, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
