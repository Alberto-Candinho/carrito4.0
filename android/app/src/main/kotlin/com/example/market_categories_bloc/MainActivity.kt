package com.example.market_categories_bloc

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        this.getWindow().setStatusBarColor(android.graphics.Color.TRANSPARENT);
    }
}

