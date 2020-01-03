import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:mega_dot_pk/widgets/branded_error_logo.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';

class BrandedImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double height;
  final double width;

  BrandedImage(this.url, {this.fit = BoxFit.cover, this.height, this.width});

  @override
  Widget build(BuildContext context) => TransitionToImage(
        fit: fit,
        height: height,
        width: width,
        alignment: Alignment.center,
        enableRefresh: true,
        image: AdvancedNetworkImage(url, useDiskCache: false),
        loadingWidget: _center(child: BrandedLoadingIndicator()),
        placeholder: _center(child: BrandedErrorLogo(showRefreshIcon: true,)),
      );

  _center({@required Widget child}) => Container(
        height: height,
        width: width,
        child: Center(
          child: child,
        ),
      );
}
