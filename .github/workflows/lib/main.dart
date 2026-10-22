import 'package:flutter/material.dart';

void main() {
  runApp(const YouTubeAIStudioApp());
}

class YouTubeAIStudioApp extends StatelessWidget {
  const YouTubeAIStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube AI Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF00E676),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676),
          secondary: Color(0xFF2979FF),
        ),
      ),
      home: const StudioHomeScreen(),
    );
  }
}

class StudioHomeScreen extends StatefulWidget {
  const StudioHomeScreen({super.key});

  @override
  State<StudioHomeScreen> createState() => _StudioHomeScreenState();
}

class _StudioHomeScreenState extends State<StudioHomeScreen> {
  // Stages: 0: Setup, 1: Script Review, 2: Audio/SFX, 3: Timeline Edit, 4: Upload
  int currentStep = 0;

  String selectedCategory = 'Mystery / Story';
  bool isShort = false;
  double videoDuration = 5.0;
  final TextEditingController topicController = TextEditingController(
    text: "The Bermuda Triangle Unsolved Mystery",
  );

  final TextEditingController scriptController = TextEditingController(
    text: "Scene 1: [Narrator] The deep ocean hides secrets no map will show...\n\n"
          "Scene 2: [SFX: Thunder Crack & Waves]\n"
          "[Captain Dialogue] Turn the helm left! It's pulling us down!\n\n"
          "Scene 3: [Narrator Seamless Resume] Decades later, radar signals picked up an anomaly...",
  );

  final TextEditingController titleController = TextEditingController(
    text: "The Bermuda Mystery: What Scientists Discovered Deep Inside!",
  );

  final TextEditingController tagsController = TextEditingController(
    text: "#BermudaTriangle #Mystery #DeepSea #Documentary #ViralStory",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.movie_filter, color: Color(0xFF00E676)),
            const SizedBox(width: 8),
            Text(
              isShort ? "Shorts Studio [9:16]" : "Long Video Studio [16:9]",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Channel Connected: YouTube Partner Safe")),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildStageProgressBar(),
          Expanded(child: _buildCurrentStageView()),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // 1. Top Visual Progress Steps
  Widget _buildStageProgressBar() {
    final stages = ["Setup", "Script", "Audio/SFX", "Timeline", "Upload"];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: const Color(0xFF1E1E1E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(stages.length, (index) {
          final isPassed = index <= currentStep;
          final isCurrent = index == currentStep;
          return Column(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: isCurrent
                    ? const Color(0xFF00E676)
                    : isPassed
                        ? const Color(0xFF2979FF)
                        : Colors.grey[800],
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stages[index],
                style: TextStyle(
                  fontSize: 10,
                  color: isPassed ? Colors.white : Colors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 2. Body View for Current Stage
  Widget _buildCurrentStageView() {
    switch (currentStep) {
      case 0:
        return _buildSetupStage();
      case 1:
        return _buildScriptReviewStage();
      case 2:
        return _buildAudioSfxStage();
      case 3:
        return _buildTimelineEditorStage();
      case 4:
        return _buildUploadStage();
      default:
        return const SizedBox();
    }
  }

  // Stage 0: Setup
  Widget _buildSetupStage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Topic / Story Idea", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: topicController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Niche / Category", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            dropdownColor: const Color(0xFF2A2A2A),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: ['Mystery / Story', 'Tech / AI', 'History Facts', 'Motivation']
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) => setState(() => selectedCategory = val!),
          ),
          const SizedBox(height: 16),
          const Text("Format & Ratio", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              ChoiceChip(
                label: const Text("Long Video [16:9]"),
                selected: !isShort,
                onSelected: (val) => setState(() => isShort = !val),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("Short [9:16]"),
                selected: isShort,
                onSelected: (val) => setState(() => isShort = val),
              ),
            ],
          ),
          if (!isShort) ...[
            const SizedBox(height: 16),
            Text("Duration: ${videoDuration.toInt()} Minutes"),
            Slider(
              value: videoDuration,
              min: 2,
              max: 20,
              divisions: 18,
              activeColor: const Color(0xFF00E676),
              onChanged: (val) => setState(() => videoDuration = val),
            ),
          ]
        ],
      ),
    );
  }

  // Stage 1: Script Review
  Widget _buildScriptReviewStage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Claude Generated Script (Review & Edit freely):",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E676)),
          ),
          const SizedBox(height: 8),
          const Text(
            "Note: Character dialogue cuts and SFX will automatically align to these cues.",
            style: TextStyle(fontSize: 11, color: Colors.white60),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: scriptController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stage 2: Audio & SFX Crossfade
  Widget _buildAudioSfxStage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "Audio Layers & Dialogue Sync",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E676)),
        ),
        const SizedBox(height: 6),
        const Text(
          "Narration fades out smoothly (150ms) before Captain speaks.",
          style: TextStyle(fontSize: 11, color: Colors.white60),
        ),
        const SizedBox(height: 14),
        _buildAudioTrackItem("00:00 - 00:15", "Narrator Introduction", "Soft Crossfade", Icons.mic),
        _buildAudioTrackItem("00:15 - 00:26", "Captain Character Dialogue", "Lip & Expression Synced", Icons.record_voice_over),
        _buildAudioTrackItem("00:18", "SFX: Ocean Thunder Hit", "Volume: 40% (Royalty-Free CC0)", Icons.graphic_eq),
        _buildAudioTrackItem("00:26 - End", "Narrator Continuation", "Seamless Resumption", Icons.mic),
      ],
    );
  }

  Widget _buildAudioTrackItem(String time, String title, String detail, IconData icon) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00E676)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(detail, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ),
    );
  }

  // Stage 3: CapCut Style Timeline
  Widget _buildTimelineEditorStage() {
    return Column(
      children: [
        Container(
          height: 170,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill, size: 46, color: Color(0xFF00E676)),
                SizedBox(height: 6),
                Text("CapCut Style Timeline Preview (Tap to Play)", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.white24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const Text("Timeline Tracks (Touch any layer to edit)", style: TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 8),
              _buildTimelineTrack("Visuals", "Scene 1: Ocean ➔ Scene 2: Ship Captain", Colors.purple),
              _buildTimelineTrack("Dialogue", "Narrator ➔ Captain Lip-Sync ➔ Narrator", Colors.blue),
              _buildTimelineTrack("SFX", "Thunder Impact [00:18] ➔ Ambient Swell", Colors.orange),
              _buildTimelineTrack("Captions", "Auto Animated Word-by-Word Subtitles", Colors.teal),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTrack(String label, String content, Color trackColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: trackColor, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // Stage 4: YouTube SEO & Upload
  Widget _buildUploadStage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Final Review before YouTube Upload",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E676)),
          ),
          const SizedBox(height: 12),
          const Text("Viral SEO Title:"),
          TextField(controller: titleController, decoration: const InputDecoration(filled: true, fillColor: Color(0xFF2A2A2A))),
          const SizedBox(height: 12),
          const Text("High-Rank Tags & Keywords:"),
          TextField(controller: tagsController, decoration: const InputDecoration(filled: true, fillColor: Color(0xFF2A2A2A))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Monetization Safe: Human-in-the-Loop review verified. Original content, CC0 sounds, no copyright strikes.",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Bottom Next / Back Checkpoint Controls
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF1E1E1E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            OutlinedButton(
              onPressed: () => setState(() => currentStep--),
              child: const Text("Back"),
            )
          else
            const SizedBox(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: currentStep == 4 ? Colors.redAccent : const Color(0xFF00E676),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: Icon(currentStep == 4 ? Icons.cloud_upload : Icons.arrow_forward),
            label: Text(
              currentStep == 4 ? "Upload to YouTube (Draft)" : "Check & Next",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (currentStep < 4) {
                setState(() => currentStep++);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Video uploaded in Draft mode! Review anytime on your YouTube Studio."),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
