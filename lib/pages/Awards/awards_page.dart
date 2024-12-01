//Andy Guest - Nov 20 2024
//frontend for the awards page

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
      backgroundColor: const Color.fromRGBO(248, 244, 234, 1), //match to the main screen bg colour
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 170, 200, 1),
        title: const Text(
          'Awards',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: Container(
              //bg for awards container
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(225, 225, 225, 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildAwardsGrid(),
            ),
          ),
        ],
      ),
    );
  }

//as in the design, this is the bar that shows the % of awards completed by the driver
  Widget _buildProgressHeader() {
    int totalAwards = awardsManager.awards.length; //check how many awards exist currently
    double unlockedPercent = awardsManager.getUnlockedAwards().length / totalAwards;
    double progressPercent = (unlockedPercent) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Color.fromRGBO(86, 170, 200, 1),
                child: Text(
                  'LD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${progressPercent.toStringAsFixed(0)}% Unlocked',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LinearProgressIndicator(
              value: progressPercent/100,
              minHeight: 16,
              backgroundColor: const Color.fromRGBO(225, 225, 225, 1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressPercent == 100 ? const Color.fromARGB(255, 7, 255, 15) : const Color.fromRGBO(86, 170, 200, 1),
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
        childAspectRatio: 1,
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
                ? [const Color.fromRGBO(86, 170, 200, 1),const Color.fromARGB(255, 75, 161, 192)] //i will change colours to match home page later
                : [Colors.white, Colors.white],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showAwardDetails(context), //open the info at the bottom when award is clicked on
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    award.icon,
                    size: 40,
                    color: award.isUnlocked ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    award.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                      color: award.isUnlocked ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    award.isUnlocked ? 'Unlocked!' : 'Locked',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: award.isUnlocked ? const Color.fromARGB(255, 217, 252, 120): Colors.grey[600],
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