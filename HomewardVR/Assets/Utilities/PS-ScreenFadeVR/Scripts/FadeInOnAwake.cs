using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PlayfulSystems.ScreenFade {
    public class FadeInOnAwake : MonoBehaviour {

        public Color fadeColor = Color.black;
        public float fadeInDuration = 1f;

        void Awake() {
            var fade = CameraFadeEffect.GetFadeEffect();
            fade.Fade(fadeColor, 1f, 0f, fadeInDuration);
        }

    }
}