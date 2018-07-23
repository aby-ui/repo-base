Description:

  RangeDisplay is a simple range display addon.  It is using spell range,
item range and interact-distance based checks to determine the approximate
range to your current target.  

RangeDisplay is a front-end to LibRangeCheck-2.0, a library addon to
calculate the range estimates. 

Note: RangeDisplay can only check for some specific distances, thus determining
a minimum and maximum range to the target. Some of these ranges are rather
large, so the range update may be slow, as it takes time to cover a bigger
distance.  Unfortunately there is no way (that I know of) of providing higher
resolution for range estimates.

Options:

Install instructions:

If you want to select different fonts, you also need:

- LibSharedMedia-3.0
- SharedMedia

After installing, RangeDisplay will be enabled by default, and unlocked,
so you'll see a semi-transparent rectangle in the center of your UI that
you can drag to a position you like.  After finding a good place for it
you should lock the frame with "/rangedisplay locked", so that it won't
eat your mouse clicks.

