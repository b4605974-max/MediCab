enum InteractionSeverity { low, moderate, severe, critical }

class DrugInteraction {
  final String drugA;
  final String drugB;
  final InteractionSeverity severity;
  final String description;
  final String clinicalRecommendation;

  const DrugInteraction({
    required this.drugA,
    required this.drugB,
    required this.severity,
    required this.description,
    required this.clinicalRecommendation,
  });
}

class DrugInteractionService {
  static final List<DrugInteraction> _knowledgeBase = [
    const DrugInteraction(
      drugA: "Ibuprofen",
      drugB: "Atorvastatin",
      severity: InteractionSeverity.moderate,
      description: "NSAIDs may modestly increase serum statin concentrations or affect renal clearance.",
      clinicalRecommendation: "Take Ibuprofen with food. Monitor for muscle tenderness or gastrointestinal discomfort.",
    ),
    const DrugInteraction(
      drugA: "Amoxicillin",
      drugB: "Methotrexate",
      severity: InteractionSeverity.severe,
      description: "Penicillins reduce the renal excretion of methotrexate, increasing toxicity risk.",
      clinicalRecommendation: "Consult your prescribing physician immediately before concurrent intake.",
    ),
    const DrugInteraction(
      drugA: "Ibuprofen",
      drugB: "Aspirin",
      severity: InteractionSeverity.severe,
      description: "Concurrent NSAID usage significantly increases the risk of gastrointestinal ulceration and bleeding.",
      clinicalRecommendation: "Avoid taking multiple NSAIDs simultaneously without explicit medical supervision.",
    ),
    const DrugInteraction(
      drugA: "Melatonin",
      drugB: "Ibuprofen",
      severity: InteractionSeverity.low,
      description: "NSAIDs taken in late evening may slightly suppress endogenous melatonin levels.",
      clinicalRecommendation: "Separate intake of Ibuprofen and Melatonin by at least 2 to 3 hours.",
    ),
  ];

  static List<DrugInteraction> checkInteractions(List<String> drugNames) {
    final List<DrugInteraction> results = [];
    final normalized = drugNames.map((d) => d.toLowerCase().trim()).toList();

    for (var rule in _knowledgeBase) {
      final a = rule.drugA.toLowerCase();
      final b = rule.drugB.toLowerCase();

      final hasA = normalized.any((name) => name.contains(a));
      final hasB = normalized.any((name) => name.contains(b));

      if (hasA && hasB) {
        results.add(rule);
      }
    }

    return results;
  }

  static List<DrugInteraction> checkNewDrug(String newDrug, List<String> currentDrugs) {
    final List<DrugInteraction> results = [];
    final newNorm = newDrug.toLowerCase().trim();

    for (var current in currentDrugs) {
      final currNorm = current.toLowerCase().trim();
      for (var rule in _knowledgeBase) {
        final a = rule.drugA.toLowerCase();
        final b = rule.drugB.toLowerCase();

        final match1 = newNorm.contains(a) && currNorm.contains(b);
        final match2 = newNorm.contains(b) && currNorm.contains(a);

        if (match1 || match2) {
          results.add(rule);
        }
      }
    }

    return results;
  }
}

