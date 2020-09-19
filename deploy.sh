# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash
kubectl create configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
kubectl create configmap config --from-file error_budget_policy.yaml -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -f app.yaml
