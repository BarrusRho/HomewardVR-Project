using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace PlayfulSystems.ScreenFade {
    public class CameraFadeEffect : MonoBehaviour {

        private bool isFading;
        private static CameraFadeEffect _instance;
        private Material fadeMaterial;

        public static CameraFadeEffect GetFadeEffect() {
            if (_instance == null) {
                _instance = FindObjectOfType<CameraFadeEffect>();

                if (_instance == null) {
                    _instance = AddFadeEffect();
                }
            }

            return _instance;
        }

        private static CameraFadeEffect AddFadeEffect() {
            if (Camera.main == null)
                return null;

            var effect = Camera.main.gameObject.AddComponent<CameraFadeEffect>();
            effect.Init();

            return effect;
        }

        private void Awake() {
            if (_instance == null) {
                _instance = this;
                Init();
            }
            else {
                Destroy(this);
            }
        }

        void Init() {
            fadeMaterial = Resources.Load<Material>("CameraFadeImageEffect");

            if (fadeMaterial == null) {
                Debug.LogError("[CameraFadeEffect] Fade Material not found in Resources/CameraFadeImageEffect");
            }

            enabled = false;
        }

        private void OnDestroy() {
            if (_instance == this)
                _instance = null;
        }

        public static bool IsFading() {
            if (_instance == null)
                return false;
            else
                return _instance.isFading;
        }

        public static void TriggerFade(Color startColor, float startAlpha, float targetAlpha, float duration, System.Action onDone = null) {
            if (_instance == null)
                GetFadeEffect();

            if (_instance != null)
                _instance.Fade(startColor, startAlpha, targetAlpha, duration, onDone);
        }

        public void Fade(Color startColor, float startAlpha, float targetAlpha, float duration, System.Action onDone = null) {
            if (fadeMaterial == null)
                return;

            isFading = true;
            enabled = true;
            StopAllCoroutines();
            StartCoroutine(DoFade(startColor, startAlpha, targetAlpha, duration, onDone));
        }

        IEnumerator DoFade(Color startColor, float startAlpha, float targetAlpha, float duration, System.Action onDone = null) {
            float time = 0f;
            fadeMaterial.SetColor("_Color", startColor);

            while (time < duration) {
                fadeMaterial.SetFloat("_Fade", Mathf.Lerp(startAlpha, targetAlpha, time / duration));
                time += Time.deltaTime;
                yield return null;
            }

            fadeMaterial.SetFloat("_Fade", targetAlpha);
            isFading = false;
            enabled = targetAlpha > 0f;

            if (onDone != null)
                onDone();
        }

        void OnRenderImage(RenderTexture src, RenderTexture dst) {
            if (enabled && fadeMaterial != null)
                Graphics.Blit(src, dst, fadeMaterial);
        }
    }
}