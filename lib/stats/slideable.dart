import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class Slideable<Widget> extends StatefulWidget{
  double? height;
  double? width;
  List<Widget> options;
  bool dots;
  Color? dotsColor;
  bool loop;
  bool arrows;
  
  Slideable({
    super.key,
    required this.options,
    this.dots = false,
    this.loop = false,
    this.arrows = false,
    this.height,
    this.width,
    this.dotsColor
  });

  @override
  State<Slideable> createState() => _SlideableState();
}

class _SlideableState extends State<Slideable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Swiper(
        itemCount: widget.options.length,
        scrollDirection: Axis.horizontal,
        loop: widget.loop,
        pagination: widget.dots ? SwiperPagination(
            margin: const EdgeInsets.all(20),
            builder: DotSwiperPaginationBuilder(activeColor: widget.dotsColor)
          ) : null,
        control: widget.arrows ? SwiperControl(
          color: Theme.of(context).colorScheme.secondaryContainer,
          disableColor: Theme.of(context).colorScheme.primaryContainer
        ) : null,
        itemBuilder: (context, index) => widget.options[index],
      ),
    );
  }
}