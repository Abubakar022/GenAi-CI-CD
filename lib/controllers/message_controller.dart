
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart'; // Your existing API service

class MessageController extends GetxController {
  var responseText = "".obs;
  var messages = <Map<String, dynamic>>[].obs;
  var isTypeing = false.obs;

  Future<void> sendMessage(String message) async {
    // Add user message to chat
    messages.add({
      'text': message,
      'isUser': true,
      'time': DateFormat('hh:mm a').format(DateTime.now())
    });

    responseText.value = "Thinking...";
    isTypeing.value = true;
    update();

    // === Prompt Engineering for Wheat Disease Domain in English ===
    String domainPrompt = """
You are an expert agronomist specializing in wheat diseases. 
Answer all questions in English. 
Provide concise explanations of the disease, symptoms, and solutions. 
If the user's question is unrelated to wheat diseases, reply: "I can only answer questions about wheat diseases."

Example 1:
User: What is Yellow Rust?
Assistant: Yellow Rust is a common wheat disease affecting leaves. Treatment: use resistant varieties.

Example 2:
User: What is Leaf Rust?
Assistant: Leaf Rust affects wheat leaves, causing small reddish spots. Treatment: apply fungicides.

User: $message
Assistant:
""";

    // Call your existing API service
    String reply = await GooglleApiService.getApiResponse(domainPrompt);

    // Add AI reply to chat
    responseText.value = reply;
    messages.add({
      'text': reply,
      'isUser': false,
      'time': DateFormat('hh:mm a').format(DateTime.now())
    });

    isTypeing.value = false;
    update();
  }
}
