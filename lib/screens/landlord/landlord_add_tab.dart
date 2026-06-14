import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_rental_app/services/property_service.dart';
import 'package:smart_rental_app/services/storage_service.dart';

import 'bc_booking_screen.dart';
import 'bc_payment_screen.dart';
import 'bc_chat_screen.dart';

class LandlordAddTab extends StatefulWidget {
  final bool dark;
  final Color glassCard;
  final Color glassBorder;

  const LandlordAddTab({
    super.key,
    required this.dark,
    required this.glassCard,
    required this.glassBorder,
  });

  @override
  State<LandlordAddTab> createState() => _LandlordAddTabState();
}

class _LandlordAddTabState extends State<LandlordAddTab> {
  int selectedOption = 0;

  final _propertyFormKey = GlobalKey<FormState>();
  final _feedFormKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  final PropertyService _propertyService = PropertyService();
  final StorageService _storageService = StorageService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController lotController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  final TextEditingController toiletsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedPropertyType = 'Apartment';
  String selectedRentalType = 'Short Term';
  String selectedBedroomType = 'Private';

  List<XFile> propertyImages = [];
  XFile? qrImage;

  final List<String> amenities = [
    'Wifi',
    'TV',
    'Kitchen',
    'Washer',
    'Air conditioning',
    'Parking',
    'Swimming pool',
    'Gym',
    'Hot water',
    'Iron',
    'Workspace',
    'Balcony',
    'Refrigerator',
    'Microwave',
    'Security',
    'Lift',
  ];

  final Set<String> selectedAmenities = {};

  final TextEditingController promoTitleController = TextEditingController();
  final TextEditingController feedCaptionController = TextEditingController();
  final TextEditingController promoDetailsController = TextEditingController();
  final TextEditingController promoDiscountController = TextEditingController();

  String selectedFeedProperty = 'Condo near KLCC';
  String selectedPromoTag = 'New Listing';
  XFile? feedImage;

  final List<String> feedPropertyOptions = [
    'Condo near KLCC',
    'Studio Apartment',
    'Cozy Family House',
  ];

  final List<String> promoTags = [
    'New Listing',
    'Limited Offer',
    'Weekend Deal',
    'Fully Furnished',
    'Last Minute',
  ];

  @override
  void dispose() {
    titleController.dispose();
    houseController.dispose();
    lotController.dispose();
    floorController.dispose();
    streetController.dispose();
    townController.dispose();
    postcodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    priceController.dispose();
    guestsController.dispose();
    bedroomsController.dispose();
    toiletsController.dispose();
    descriptionController.dispose();

    promoTitleController.dispose();
    feedCaptionController.dispose();
    promoDetailsController.dispose();
    promoDiscountController.dispose();
    super.dispose();
  }

  String get fullAddressPreview {
    final parts = [
      if (houseController.text.trim().isNotEmpty)
        'House/Unit ${houseController.text.trim()}',
      if (lotController.text.trim().isNotEmpty)
        'Lot ${lotController.text.trim()}',
      if (floorController.text.trim().isNotEmpty)
        'Floor ${floorController.text.trim()}',
      if (streetController.text.trim().isNotEmpty) streetController.text.trim(),
      if (townController.text.trim().isNotEmpty) townController.text.trim(),
      if (postcodeController.text.trim().isNotEmpty)
        postcodeController.text.trim(),
      if (cityController.text.trim().isNotEmpty) cityController.text.trim(),
      if (stateController.text.trim().isNotEmpty) stateController.text.trim(),
    ];
    return parts.join(', ');
  }

  bool get showLocationPreview {
    return streetController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        stateController.text.trim().isNotEmpty;
  }

  Future<void> pickPropertyImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 85);
    if (images.isNotEmpty) {
      setState(() {
        propertyImages = images;
      });
    }
  }

  Future<void> pickQrImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        qrImage = image;
      });
    }
  }

  Future<void> pickFeedImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        feedImage = image;
      });
    }
  }

  Future<void> _saveProperty() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final String fullAddress = [
        houseController.text.trim(),
        lotController.text.trim(),
        floorController.text.trim(),
        streetController.text.trim(),
        townController.text.trim(),
        postcodeController.text.trim(),
        cityController.text.trim(),
        stateController.text.trim(),
      ].where((item) => item.isNotEmpty).join(', ');

      final List<String> imagePaths = propertyImages
          .map((image) => image.path)
          .toList();

      final List<String> imageUrls = await _storageService.uploadMultipleImages(
        folderName: 'property_images/${user.uid}',
        filePaths: imagePaths,
      );

      String qrImageUrl = '';

      if (qrImage != null) {
        qrImageUrl = await _storageService.uploadImage(
          folderName: 'qr_images/${user.uid}',
          filePath: qrImage!.path,
        );
      }

      await _propertyService.addProperty(
        title: titleController.text.trim(),
        location: fullAddress,
        price: priceController.text.trim(),
        description: descriptionController.text.trim(),
        type: selectedPropertyType,
        stayCategory: selectedRentalType,
        lat: 3.1390,
        lng: 101.6869,
        landlordId: user.uid,
        landlordName: user.displayName ?? 'Landlord',
        images: imageUrls,
        qrImage: qrImageUrl,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property added successfully.')),
      );

      titleController.clear();
      houseController.clear();
      lotController.clear();
      floorController.clear();
      streetController.clear();
      townController.clear();
      postcodeController.clear();
      cityController.clear();
      stateController.clear();
      priceController.clear();
      guestsController.clear();
      bedroomsController.clear();
      toiletsController.clear();
      descriptionController.clear();

      setState(() {
        propertyImages.clear();
        qrImage = null;
        selectedAmenities.clear();
        selectedPropertyType = 'Apartment';
        selectedRentalType = 'Short Term';
        selectedBedroomType = 'Private';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save property: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = widget.dark
        ? Colors.white70
        : const Color(0xFF7B6243);
    final Color goldText = widget.dark
        ? const Color(0xFFE6BC6D)
        : const Color(0xFFC9A24A);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add a new property listing or create a feed post to promote your place.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildTopToggle(),
          const SizedBox(height: 20),
          if (selectedOption == 0)
            _buildAddPropertySection(primaryText, secondaryText, goldText)
          else
            _buildAddFeedSection(primaryText, secondaryText, goldText),
        ],
      ),
    );
  }

  Widget _buildTopToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: widget.glassCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              title: "Add Property",
              selected: selectedOption == 0,
              onTap: () {
                setState(() {
                  selectedOption = 0;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _toggleButton(
              title: "Add Feed",
              selected: selectedOption == 1,
              onTap: () {
                setState(() {
                  selectedOption = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? const Color(0xFFC9A24A) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (widget.dark ? Colors.white70 : const Color(0xFF5C4630)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPropertySection(
    Color primaryText,
    Color secondaryText,
    Color goldText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: widget.glassCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Form(
        key: _propertyFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Property Listing",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Fill in the full details of your property so tenants can understand the place clearly.",
              style: GoogleFonts.inter(
                fontSize: 12.8,
                color: secondaryText,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),

            _buildLabel("Property Title"),
            _buildTextField(
              controller: titleController,
              hintText: "Eg. Luxury Condo near KLCC",
            ),

            const SizedBox(height: 18),
            _buildSectionMiniTitle("Location Details", goldText),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: houseController,
                    hintText: "House / Unit",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: lotController,
                    hintText: "Lot",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(controller: floorController, hintText: "Floor"),
            const SizedBox(height: 12),
            _buildTextField(
              controller: streetController,
              hintText: "Street address",
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: townController,
                    hintText: "Town",
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: postcodeController,
                    hintText: "Postcode",
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    hintText: "City",
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: stateController,
                    hintText: "State",
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            if (showLocationPreview) ...[
              const SizedBox(height: 14),
              _buildLocationPreviewCard(primaryText, secondaryText),
            ],

            const SizedBox(height: 18),
            _buildLabel("Price"),
            _buildTextField(
              controller: priceController,
              hintText: "Eg. RM180 / night",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 14),
            _buildLabel("Property Type"),
            _buildDropdown(
              value: selectedPropertyType,
              items: const [
                'Apartment',
                'Condo',
                'House',
                'Studio',
                'Room',
                'Villa',
                'Homestay',
              ],
              onChanged: (value) {
                setState(() {
                  selectedPropertyType = value!;
                });
              },
            ),

            const SizedBox(height: 14),
            _buildLabel("Rental Type"),
            _buildDropdown(
              value: selectedRentalType,
              items: const ['Short Term', 'Medium Term', 'Long Term'],
              onChanged: (value) {
                setState(() {
                  selectedRentalType = value!;
                });
              },
            ),

            const SizedBox(height: 18),
            _buildSectionMiniTitle("Property Capacity", goldText),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: guestsController,
                    hintText: "Guests",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: bedroomsController,
                    hintText: "Bedrooms",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: toiletsController,
                    hintText: "Toilets",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            _buildLabel("Bedroom Type"),
            _buildDropdown(
              value: selectedBedroomType,
              items: const ['Private', 'Dedicated', 'Shared'],
              onChanged: (value) {
                setState(() {
                  selectedBedroomType = value!;
                });
              },
            ),

            const SizedBox(height: 18),
            _buildSectionMiniTitle("What your place offers", goldText),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: amenities.map((item) {
                final bool selected = selectedAmenities.contains(item);
                return FilterChip(
                  label: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : (widget.dark
                                ? Colors.white70
                                : const Color(0xFF5C4630)),
                    ),
                  ),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedAmenities.add(item);
                      } else {
                        selectedAmenities.remove(item);
                      }
                    });
                  },
                  backgroundColor: widget.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.85),
                  selectedColor: const Color(0xFFC9A24A),
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFFC9A24A)
                        : widget.glassBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),
            _buildLabel("Description"),
            _buildTextField(
              controller: descriptionController,
              hintText:
                  "Describe the property, facilities, style, vibe and who it suits best",
              maxLines: 5,
            ),

            const SizedBox(height: 18),
            _buildSectionMiniTitle("Images", goldText),
            const SizedBox(height: 10),
            _buildImagePickerArea(
              title: "Upload Property Photos",
              subtitle: "Minimum 5 images required",
              onTap: pickPropertyImages,
              images: propertyImages,
            ),

            const SizedBox(height: 18),
            _buildSectionMiniTitle("Payment QR", goldText),
            const SizedBox(height: 10),
            _buildImagePickerArea(
              title: "Upload Payment QR",
              subtitle: "Upload your DuitNow or bank QR image",
              onTap: pickQrImage,
              images: qrImage == null ? [] : [qrImage!],
            ),

            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final bool validForm =
                      _propertyFormKey.currentState?.validate() ?? false;

                  if (selectedAmenities.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select at least one amenity."),
                      ),
                    );
                    return;
                  }

                  if (propertyImages.length < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please upload at least 5 property images.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (qrImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please upload your payment QR image."),
                      ),
                    );
                    return;
                  }

                  if (validForm) {
                    await _saveProperty();
                  }
                },
                icon: const Icon(Icons.add_home_work_rounded),
                label: const Text("Publish Property"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A24A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFeedSection(
    Color primaryText,
    Color secondaryText,
    Color goldText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: widget.glassCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Form(
        key: _feedFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Feed Promotion",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Promote your listing with a stronger visual post and clear booking message.",
              style: GoogleFonts.inter(
                fontSize: 12.8,
                color: secondaryText,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),

            _buildLabel("Post Title"),
            _buildTextField(
              controller: promoTitleController,
              hintText: "Eg. Weekend Special Promo",
            ),

            const SizedBox(height: 14),
            _buildLabel("Related Property"),
            _buildDropdown(
              value: selectedFeedProperty,
              items: feedPropertyOptions,
              onChanged: (value) {
                setState(() {
                  selectedFeedProperty = value!;
                });
              },
            ),

            const SizedBox(height: 14),
            _buildLabel("Promo Tag"),
            _buildDropdown(
              value: selectedPromoTag,
              items: promoTags,
              onChanged: (value) {
                setState(() {
                  selectedPromoTag = value!;
                });
              },
            ),

            const SizedBox(height: 14),
            _buildLabel("Caption"),
            _buildTextField(
              controller: feedCaptionController,
              hintText: "Eg. Cozy stay near KLCC with special price this week!",
              maxLines: 3,
            ),

            const SizedBox(height: 14),
            _buildLabel("Promotion Details"),
            _buildTextField(
              controller: promoDetailsController,
              hintText: "Eg. Fully furnished with city view and fast wifi",
              maxLines: 3,
            ),

            const SizedBox(height: 14),
            _buildLabel("Discount / Special Note"),
            _buildTextField(
              controller: promoDiscountController,
              hintText: "Eg. 10% off for early bookings",
            ),

            const SizedBox(height: 18),
            _buildImagePickerArea(
              title: "Upload Feed Image",
              subtitle: "Add one strong promo image",
              onTap: pickFeedImage,
              images: feedImage == null ? [] : [feedImage!],
            ),

            const SizedBox(height: 18),
            _buildFeedPreviewCard(primaryText, secondaryText, goldText),

            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final bool validForm =
                      _feedFormKey.currentState?.validate() ?? false;

                  if (feedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please upload one feed image."),
                      ),
                    );
                    return;
                  }

                  if (validForm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Feed promotion posted successfully."),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text("Post Promotion"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A24A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: widget.dark ? Colors.white : const Color(0xFF2B2118),
        ),
      ),
    );
  }

  Widget _buildSectionMiniTitle(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        color: widget.dark ? Colors.white : const Color(0xFF1D1D1F),
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: widget.dark ? Colors.white38 : Colors.grey.shade600,
          fontSize: 13,
        ),
        filled: true,
        fillColor: widget.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.82),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: widget.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: widget.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFC9A24A), width: 1.3),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: widget.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: widget.glassBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: widget.dark ? const Color(0xFF1A2236) : Colors.white,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: widget.dark ? Colors.white : const Color(0xFF1D1D1F),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLocationPreviewCard(Color primaryText, Color secondaryText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: widget.dark
            ? const Color(0xFF1F2937).withOpacity(0.95)
            : const Color(0xFFE6BC6D).withOpacity(0.12),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Text(
        fullAddressPreview,
        style: GoogleFonts.inter(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: secondaryText,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildImagePickerArea({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required List<XFile> images,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.glassBorder),
              color: widget.dark
                  ? Colors.white.withOpacity(0.03)
                  : const Color(0xFFFFFBF6),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 34,
                  color: Color(0xFFC9A24A),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: widget.dark ? Colors.white : const Color(0xFF2B2118),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.3,
                    color: widget.dark ? Colors.white60 : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${images.length} image${images.length == 1 ? '' : 's'} selected",
                  style: GoogleFonts.inter(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC9A24A),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(images[index].path),
                    width: 86,
                    height: 86,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeedPreviewCard(
    Color primaryText,
    Color secondaryText,
    Color goldText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feed Preview",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: goldText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            promoTitleController.text.trim().isEmpty
                ? "Your post title will appear here"
                : promoTitleController.text.trim(),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$selectedPromoTag • $selectedFeedProperty",
            style: GoogleFonts.inter(
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              color: goldText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedCaptionController.text.trim().isEmpty
                ? "Your caption preview will appear here."
                : feedCaptionController.text.trim(),
            style: GoogleFonts.inter(
              fontSize: 12.6,
              fontWeight: FontWeight.w500,
              color: secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
