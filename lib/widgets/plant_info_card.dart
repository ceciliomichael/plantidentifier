import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/app_theme.dart';

class PlantInfoCard extends StatelessWidget {
  final Plant plant;

  const PlantInfoCard({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing,
        vertical: AppTheme.spacingSmall,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant name and scientific name
            Text(
              plant.name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              plant.scientificName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            // Family and native region
            if (plant.family.isNotEmpty || plant.nativeRegion.isNotEmpty)
              const SizedBox(height: AppTheme.spacingSmall),
            
            if (plant.family.isNotEmpty)
              Text(
                'Family: ${plant.family}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
            if (plant.nativeRegion.isNotEmpty)
              Text(
                'Native to: ${plant.nativeRegion}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
            const SizedBox(height: AppTheme.spacingMedium),
            
            // Description
            if (plant.description.isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                plant.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
            ],
            
            // Care instructions
            if (plant.careInstructions.isNotEmpty) ...[
              Text(
                'Care Instructions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              ...plant.careInstructions.map((instruction) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.eco_outlined,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(
                        instruction,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: AppTheme.spacingMedium),
            ],
            
            // Additional information
            if (plant.additionalInfo.isNotEmpty) ...[
              Text(
                'Additional Information',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              ...plant.additionalInfo.map((info) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(
                        info,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
} 