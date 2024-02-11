// utils/getPlanetImage.js
import image1 from '../../assets/planets/1.webp'
import image2 from '../../assets/planets/2.webp'
import image3 from '../../assets/planets/3.webp'
import image4 from '../../assets/planets/4.webp'
import image5 from '../../assets/planets/5.webp'
import image6 from '../../assets/planets/6.webp'
import image7 from '../../assets/planets/7.webp'
import image8 from '../../assets/planets/8.webp'
import image9 from '../../assets/planets/9.webp'
import image10 from '../../assets/planets/10.webp'

export type ImageId = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10

const planetImages = {
  '1.webp': image1,
  '2.webp': image2,
  '3.webp': image3,
  '4.webp': image4,
  '5.webp': image5,
  '6.webp': image6,
  '7.webp': image7,
  '8.webp': image8,
  '9.webp': image9,
  '10.webp': image10
}

export const getPlanetImage = (imageId: ImageId) => {
  return planetImages[`${imageId}.webp`]
}
