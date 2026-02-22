from django.http import JsonResponse
import socket

def health(request):
    return JsonResponse({
        "status": "ok",
        "hostname": "akshat_machine"
    })
