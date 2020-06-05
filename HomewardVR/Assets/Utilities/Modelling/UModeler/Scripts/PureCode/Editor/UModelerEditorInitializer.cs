using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using tripolygon.UModeler;

namespace TPUModelerEditor
{
    [InitializeOnLoadAttribute]
    public static class UModelerEditorInitializer
    {
        static UModelerEditorInitializer()
        {
            UMContext.Init(new EditorEngine());

            Selection.selectionChanged += HandleOnSelectionChanged;
            Builder.callback += OnMeshBuilt;
            UnityEditor.SceneManagement.EditorSceneManager.sceneOpened += OnSceneLoaded;
            UnityEditor.SceneManagement.EditorSceneManager.sceneSaving += OnSceneSaving;
            PrefabUtility.prefabInstanceUpdated += PrefabInstanceUpdated;

#if UNITY_2017_2_OR_NEWER
            EditorApplication.playModeStateChanged += OnPlayModeChanged;
#else
            EditorApplication.playmodeStateChanged += HandleOnPlayModeChanged;
#endif

#if UNITY_2019_1_OR_NEWER
            SceneView.duringSceneGui += UModelerEditor.OnScene;
#else
            SceneView.onSceneGUIDelegate += UModelerEditor.OnScene;
#endif
        }

        public static void HandleOnSelectionChanged()
        {
            UModelerEditor.SendMessage(UModelerMessage.SelectionChanged);

            if (UMContext.activeModeler != null)
            {
                EditorMode.commentaryViewer.AddTitleNoDuplilcation("[" + UMContext.activeModeler.gameObject.name + "] Object has been selected.");
            }
        }

#if UNITY_2017_2_OR_NEWER
        public static void OnPlayModeChanged(PlayModeStateChange state)
        {
            if (state == PlayModeStateChange.ExitingEditMode)
            {
                if (EditorMode.currentTool != null && UMContext.activeModeler != null)
                {
                    EditorMode.currentTool.End();
                    EditorMode.currentTool.Start();
                }

                if (Selection.activeGameObject != null)
                {
                    if (Selection.activeGameObject.GetComponent<UModeler>() != null)
                    {
                        Selection.activeGameObject = null;
                    }
                }
            }

            if (state == PlayModeStateChange.EnteredPlayMode || state == PlayModeStateChange.EnteredEditMode)
            {
                MenuItems.RefreshAll();
                EditorUtil.DisableHasTransformed();
            }
        }
#else
        public static void HandleOnPlayModeChanged()
        {
            bool bExitingEditMode = !EditorApplication.isPlaying &&  EditorApplication.isPlayingOrWillChangePlaymode;
            bool bEnteredEditMode = !EditorApplication.isPlaying && !EditorApplication.isPlayingOrWillChangePlaymode;
            bool bEnteredPlayMode =  EditorApplication.isPlaying &&  EditorApplication.isPlayingOrWillChangePlaymode;

            if (bExitingEditMode)
            {
                if (EditorMode.currentTool != null && UMContext.activeModeler != null)
                {
                    EditorMode.currentTool.End();
                    EditorMode.currentTool.Start();
                }

                if (Selection.activeGameObject != null)
                {
                    if (Selection.activeGameObject.GetComponent<UModeler>() != null)
                    {
                        Selection.activeGameObject = null;
                    }
                }
            }

            if (bEnteredPlayMode || bEnteredEditMode)
            {
                MenuItems.RefreshAll();
                EditorUtil.DisableHasTransformed();
            }
        }
#endif

        static void OnSceneLoaded(Scene scene, UnityEditor.SceneManagement.OpenSceneMode mode)
        {
            EditorUtil.DisableHasTransformed();
        }

        static void OnSceneSaving(Scene scene, string path)
        {
            if (UMContext.activeModeler != null && EditorMode.currentTool != null)
            {
                EditorMode.currentTool.End();
                EditorMode.currentTool.Start();
            }
        }

        static void OnMeshBuilt(UModeler modeler, int shelf)
        {
            UModelerEditor.OnChanged();
            EditorUtil.EnableHighlight(false, modeler);
        }

        static public void PrefabInstanceUpdated(GameObject instance)
        {
            GameObject prefab = EditorUtil.GetCorrespoindingPrefabObject(instance);

            if (prefab != null)
            {
                MeshFilter prefabMeshFilter = prefab.GetComponent<MeshFilter>();
                if (prefabMeshFilter != null && prefabMeshFilter.sharedMesh == null)
                {
                    MeshFilter instanceMeshFilter = instance.GetComponent<MeshFilter>();
                    if (instanceMeshFilter != null && instanceMeshFilter.sharedMesh != null)
                    {
                        prefabMeshFilter.sharedMesh = instanceMeshFilter.sharedMesh;
                        prefabMeshFilter.sharedMesh.UploadMeshData(false);
                    }
                }
            }

            GameObject[] allObjects = GameObject.FindObjectsOfType<GameObject>();
            for (int i = 0; i < allObjects.Length; ++i)
            {
                UModeler modeler = allObjects[i].GetComponent<UModeler>();
                if (modeler == null)
                {
                    continue;
                }

                if (EditorUtil.GetCorrespoindingPrefabObject(allObjects[i]) == prefab)
                {
                    modeler.Build(-1, true/*updateToGraphicsAPIImmediately*/);
                }
            }

            EditorUtil.RepaintScene();

            if (UMContext.activeModeler != null && !EditorUtil.IsPrefab(UMContext.activeModeler.gameObject))
            {
                EditorMode.currentTool.End();
                EditorMode.currentTool.Start();
            }
        }
    }
}