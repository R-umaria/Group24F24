import 'package:flutter/material.dart';
import './award_backend.dart';

class AwardsPage extends StatelessWidget {
  final AwardsManager awardsManager;

  const AwardsPage({
    super.key,
    required this.awardsManager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Awards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: _buildAwardsGrid(),
          ),
        ],
      ),
    );
  }

//as in the design, this is the bar that shows the % of awards completed by the driver
  Widget _buildProgressHeader() {
    int totalAwards = awardsManager.awards.length; //check how many awards exist currently
    double unlockedPercent = awardsManager.getUnlockedAwards().length / totalAwards;
    double progressPercent = (unlockedPercent / totalAwards) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '$progressPercent% Unlocked',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LinearProgressIndicator(
              value: progressPercent/100,
              minHeight: 20,
              backgroundColor: const Color.fromARGB(255, 214, 210, 210),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressPercent == 100 ? const Color.fromARGB(255, 7, 255, 15) : const Color.fromARGB(255, 73, 215, 227),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //holds all awards cards
  Widget _buildAwardsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: awardsManager.awards.length,
      itemBuilder: (context, index) {
        final award = awardsManager.awards[index];
        return _AwardCard(award: award);
      },
    );
  }
}

//holds a single award
class _AwardCard extends StatelessWidget {
  final Award award;
  const _AwardCard({
    required this.award,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: award.isUnlocked
                ? [Colors.blue[400]!, Colors.blue[600]!] //i will change colours to match home page later
                : [Colors.grey[300]!, Colors.grey[400]!],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showAwardDetails(context), //open the info at the bottom when award is clicked on
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    award.icon,
                    size: 48,
                    color: award.isUnlocked ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    award.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: award.isUnlocked ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    award.isUnlocked ? 'Unlocked!' : 'Locked',
                    style: TextStyle(
                      fontSize: 14,
                      color: award.isUnlocked ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//show info like description when the award is clicked on
  void _showAwardDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(award.icon,
              size: 64,
              color: award.isUnlocked ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              award.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              award.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (award.isUnlocked && award.unlockedDate != null)
              Text(
                'Unlocked on ${_formatDate(award.unlockedDate!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}